###
滑动手势
@class Swipe
@author qiang.hu
###
Swipe =
  
  ###
  手指开始移动前滑动对象的相对位置（相对于原始位置）
  ###
  startX: 0
  
  ###
  手指开始移动时在屏幕上的位置
  ###
  startPoint: [
    0
    0
  ]
  
  ###
  手指移动过程中滑动对象当前的相对位置（相对于原始位置）
  ###
  lastX: 0
  
  ###
  滑动的页码标记
  ###
  page: 1
  
  ###
  滑动容器的总页数
  ###
  pageCount: 1
  
  ###
  滑动容器的宽度
  ###
  scrollerWidth: 0
  
  ###
  窗口的innerWidth，用来缓存
  ###
  windowWidth: 0
  initiated: false
  events:
    onTouchStart: START_EVENT
    onTouchMove: MOVE_EVENT
    onTouchEnd: END_EVENT

  init: ->
    Swipe.initScroller()
    $(DOC).on(Swipe.events.onTouchEnd, Swipe.onTouchEnd).on(Swipe.events.onTouchMove, Swipe.onTouchMove).on("touchcancel", Swipe.onTouchCancel).on "click", Swipe.onTouchCancel
    return

  initScroller: (elWrap) ->
    elWrap = elWrap or DOC
    $(".scroll_wrap", elWrap).css
      webkitBackfaceVisibility: "hidden"
      overflowX: "hidden"
      webkitTransform: "translate3d(0,0,0)"

    $(".scroller", elWrap).css(
      webkitBackfaceVisibility: "hidden"
      webkitTransform: "translate3d(0,0,0)"
      webkitTransition: "-webkit-transform 0"
    ).on(Swipe.events.onTouchStart, Swipe.onTouchStart).on "webkitTransitionEnd", ->
      page = $(this).attr("page") or 1
      elPages = $(".scroller_page b", @parentNode)
      elPages.removeClass "c"
      elPages.eq(page - 1).addClass "c"
      return

    return

  
  ###
  滚动使传入的el在窗口中可见
  ###
  scrollToElement: (el, animation, force) ->
    elScroller = el.parent()
    return  if elScroller.length is 0
    elScrollerTag = elScroller.get(0)
    paddingLeft = elScrollerTag.offsetLeft
    paddingRight = elScrollerTag.offsetLeft
    
    # TODO: 
    toX = -(el.offset().left - paddingLeft)
    lastCell = elScrollerTag["lastElementChild"]
    scrollerWidth = lastCell.offsetLeft + lastCell.offsetWidth + paddingLeft + paddingRight
    windowWidth = elScroller.parent().width()
    maxX = scrollerWidth - windowWidth
    startX = parseInt(elScroller.attr("startX") or 0)
    
    # 如果滚动区域的子条目已经完全显示在屏幕上则不需要滚动 
    return  if toX < startX and (-toX + el.width()) < (-startX + windowWidth) and not force
    toX = -maxX  if toX < -maxX
    toX = 0  if toX > 0
    elScroller.attr("startX", toX).css
      webkitTransform: "translate3d(" + toX + "px,0,0)"
      webkitTransitionDuration: ((if animation then "200ms" else 0))

    return

  onTouchStart: (e) ->
    elTag = this
    el = $(this)
    cellCount = elTag["childElementCount"]
    if cellCount > 0
      
      # 计算滚动容器的宽度 
      Swipe.scrollerWidth = 0
      Swipe.leftPadding = elTag.offsetLeft
      Swipe.rightPadding = elTag.offsetLeft # TODO:
      lastCell = elTag["lastElementChild"]
      Swipe.scrollerWidth = lastCell.offsetLeft + lastCell.offsetWidth + Swipe.leftPadding + Swipe.rightPadding  if lastCell
      
      # 如果内容区域小于滚动区域尺寸，则不滚动 
      return  if Swipe.scrollerWidth <= elTag.parentNode.offsetWidth
      Swipe.touchElement = el
      Swipe.initiated = true
      el.css "webkitTransitionDuration", "0"
      
      # 手指开始移动前滑动对象的相对位置（相对于原始位置） 
      Swipe.startX = parseInt(el.attr("startX") or 0, 10)
      
      # 分页滚动的边界对象 
      Swipe.paginationElLeft = null
      Swipe.paginationElRight = null
      Swipe.windowWidth = el.parent().width()
      
      # 找出第一个没有完全显示在屏幕上的对象，作为分页滚动的边界对象 
      elCell = elTag["firstElementChild"]
      loop
        offsetLeft = $(elCell).get(0).offsetLeft
        Swipe.paginationElLeft = elCell  if not Swipe.paginationElLeft and (offsetLeft + Swipe.startX >= 0)
        if offsetLeft + elCell.offsetWidth + Swipe.startX > Swipe.windowWidth
          Swipe.paginationElRight = elCell
          break
        break unless elCell = elCell.nextElementSibling
      
      # 滚动区域没有超出边界的滑动距离  
      Swipe.deltaXInsetBound = 0
      event = e.originalEvent
      Swipe.startPoint = [
        event.clientX
        event.clientY
      ]
    return

  onTouchMove: (e) ->
    return  if false is Swipe.initiated
    event = e.originalEvent
    
    # 手指移动过程中滑动对象当前的相对位置（相对于原始位置） 
    deltaX = event.clientX - Swipe.startPoint[0]
    deltaY = event.clientY - Swipe.startPoint[1]
    
    # 当滑动到左右边界的时候做滑动距离的衰减 
    if deltaX > 0 and Swipe.startX >= 0
      
      # 向右滑动 
      Swipe.lastX = Swipe.startX + deltaX / 2
    else if deltaX < 0 and (-Swipe.startX - deltaX >= Swipe.scrollerWidth - Swipe.windowWidth)
      
      # 向左滑动越过右边界 
      Swipe.lastX = -(Swipe.scrollerWidth - Swipe.windowWidth) + (deltaX - Swipe.deltaXInsetBound) / 2
    else
      
      # 在滑动中间部分，距离无衰减 
      Swipe.lastX = Swipe.startX + deltaX
      Swipe.deltaXInsetBound = deltaX
    unless Swipe.isSwiping
      if Math.abs(deltaY) > Math.abs(deltaX)
        Swipe.initiated = false
        return
    e.preventDefault()
    Swipe.isSwiping = true
    Swipe.setPos Swipe.lastX
    return

  onTouchEnd: (e) ->
    if Swipe.isSwiping
      toX = 0
      page = Swipe.touchElement.attr("page") or 1
      if Swipe.lastX < Swipe.startX
        
        # 向左滑动
        if Swipe.paginationElRight
          toX = Swipe.paginationElRight.offsetLeft * -1
          page++
        else
          toX = Swipe.paginationElLeft.offsetLeft * -1
        maxX = Swipe.scrollerWidth - Swipe.windowWidth
        toX = -maxX  if toX < -maxX
      else if Swipe.lastX > Swipe.startX
        
        # 向右滑动
        if Swipe.paginationElLeft
          elCell = Swipe.paginationElLeft
          maxOffsetX = Swipe.windowWidth - elCell.offsetWidth - elCell.offsetLeft
          
          # 计算滑动距离，使滑动后的位置，让左边的分页边界对象位于右边的不超过窗口的区域 
          loop
            toX = elCell.offsetLeft * -1
            if toX > maxOffsetX
              page--
              break
            break unless elCell = elCell.previousElementSibling
      Swipe.touchElement.attr "page", page
      toX = 0  if toX > 0
      Swipe.touchElement.attr "startX", toX
      Swipe.touchElement.css "webkitTransitionDuration", "200ms"
      Swipe.setPos toX
      e.preventDefault()
      
      # 清除工作 
      Swipe.onTouchCancel()
    return

  onTouchCancel: ->
    Swipe.isSwiping = false
    Swipe.initiated = false
    Swipe.touchElement = null
    return

  
  #
  #   * 设置滑动位置
  #   
  setPos: (x) ->
    Swipe.touchElement.css "webkitTransform", "translate3d(" + x + "px,0,0)"
    return

$().ready ->
  Swipe.init()
  $(WIN).on "resize", ->
    $(".scroller").each (element) ->
      page = element.getAttribute("page") or 1
      Swipe.scrollToElement $(element).children().eq(page - 1)
      return

    return

  return


# 在web浏览器中拖动链接或图片的时候不会中断 
unless IsTouch
  RR.addEvent "mousedown", DOC, ((e) ->
    e = new RR.event(e)
    elCur = e.target
    while elCur
      nodeName = elCur.nodeName
      if "A" is nodeName or "IMG" is nodeName
        e.preventDefault()
        break
      elCur = elCur.parentNode
    return
  ), false
