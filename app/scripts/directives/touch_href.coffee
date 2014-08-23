( (window, angular) ->

  ###
  angualr 指令
  目的是链接跳转采用touch事件模拟，跳转行为响应更快
  ###

  'use strict'

  ngTouchHref = angular.module 'binnng.touch.href', []

  WIN = window
  IsTouch = "ontouchend" of WIN
  
  # 如果不是移动设备，什么都不做
  return no if not IsTouch 

  LOC = location
  NA = WIN.navigator
  UA = NA.userAgent

  IsAndroid = (/Android|HTC/i.test(UA) or /Linux/i.test(NA.platform + "")) 

  # 手指移动距离超过这个不算点击
  MOVE_BUFFER_RADIUS = if IsAndroid then 10 else 6

  getCoordinates = (event) ->
    touches = event.touches && if event.touches.length then event.touches else [event]
    e = (event.changedTouches && event.changedTouches[0]) ||
        (event.originalEvent && event.originalEvent.changedTouches &&
            event.originalEvent.changedTouches[0]) ||
        touches[0].originalEvent || touches[0]

    x: e.clientX
    y: e.clientY


  # 去除自带的ngHref
  # 不要去除，作为其扩展
  # ngTouchHref.config ($provide) ->
  #   $provide.decorator "ngHrefDirective", ($delegate) ->

  #     $delegate.shift()
  #     $delegate

  ngTouchHref.directive "ngHref", ->


    link: (scope, element, attrs) ->

      if element[0]?.tagName.toUpperCase() is "A"

        totalX = totalY = 0
        startCoords = lastPos = null
        active = no

        onTouchStart = (event) ->
          startCoords = getCoordinates event
          active = yes
          lastPos = startCoords

        onTouchCancel = (event) ->
          active = no

        onTouchMove = (event) ->

          return no if not active and not startCoords

          coords = getCoordinates event

          totalX += Math.abs(coords.x - lastPos.x)
          totalY += Math.abs(coords.y - lastPos.y)

          lastPos = coords

          return no if totalX < MOVE_BUFFER_RADIUS and totalY < MOVE_BUFFER_RADIUS

          # 这个是 swipe
          if totalY > totalX
            active = no
          else
            event.preventDefault()

        onTouchEnd = (event) ->
          return no if not active

          active = no

          event.preventDefault?()
          event.stopPropagation?()

          LOC["href"] = attrs.ngHref


        element.on "touchstart", onTouchStart
        element.on "touchcancel", onTouchCancel
        element.on "touchmove", onTouchMove
        element.on "touchend", onTouchEnd

) window, angular
