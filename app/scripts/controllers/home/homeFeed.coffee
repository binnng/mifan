
Mifan.controller "homeFeed", ($scope, $http) ->

  feed = 
    init: ->


  feed.init()

  $scope.toggleMBubble = (index) ->
    $scope.newsCollect[index].bblActv = not $scope.newsCollect[index].bblActv

  $scope.setMBill = (index) ->

    $scope.toggleMBill ["love", "comment", "share"]


  loveAns = 
    init: ->
      $scope.loveAns = loveAns.send
      $scope.$on "loveansCb", (event, data) -> loveAns.sendCb data

    feed: null

    send: (item, point) ->
      return no if item.love.iflove

      data = 
        answerid: item.answer.answerid

      loveAns.feed = item

      $scope.$emit "loveans", data

    sendCb: (data) ->
      {ret, msg, result} = data
      toastType = ""

      if String(ret) is "100000"
        loveAns.feed.love.iflove = 1
        loveAns.feed.answer.digg = result
        msg = "喜欢成功"
      else
        toastType = "warn"

      $scope.toast msg, toastType
        
  loveAns.init()


  comment = 
    init: ->
      $scope.comment = comment.send
      $scope.$on "commentCb", (e, data) -> comment.sendCb data
      $scope.$on "getcommentCb", (e, data) -> comment.getCb data
      $scope.expandCmtFn = comment.expand
      $scope.expandReplyFn = comment.replyExpand
      $scope.reply = comment.reply


    point: null
    feed: null
    getcommentFeed: null
    content: ""

    send: (news, point, isReply) ->
      point.isSendingCmt = yes
      content = if isReply then "回复@#{comment.replyUsername}: #{point.rplContent}" else point.cmtContent

      comment.content = content
      
      $scope.$emit "comment", 
        askid: news.ask.askid
        answerid: news.answer.answerid
        content: content

      comment.point = point
      comment.feed = news

    sendCb: (data) ->
      {ret, msg, result} = data
      toastType = ""

      if String(ret) is "100000"
      else
        toastType = "warn"

      $scope.toast msg
      comment.point.isSendingCmt = no
      comment.point.isSendingRpl = no
      comment.point.cmtContent = ""
      comment.point.rplContent = ""

      comment.point.expandReply = no

      user = $scope.user

      cmt = 
        content: comment.content
        addtime: (+ new Date)
        user:
          "userid": user.userid
          "username": user.username
          "email": user.email
          "face": user.email
          "path": user.path
          "face_120": user.face_120
          "face_60": user.face_60

      comment.feed.comment.splice 0, 0, cmt

    expand: (feed, point) ->
      point.expandCmt = not point.expandCmt
      if point.expandCmt
        comment.get(feed, point)
        comment.getcommentFeed = feed

    get: (feed, point) ->
      data = 
        answerid: feed.answer.answerid

      $scope.$emit "getcomment", data

    getCb: (data) ->
      {ret, msg, result} = data
      comment.getcommentFeed.comment = result

    replyExpand: (feed, point) ->
      point.expandReply = not point.expandReply


    replyUsername: ""

    reply: (index, feed, point) ->
      cmt = feed.comment[index]
      username = cmt.user.username

      comment.replyUsername = username
      point.isSendingRpl = yes
      comment.send feed, point, yes

    replyCb: (data) ->







  comment.init()


