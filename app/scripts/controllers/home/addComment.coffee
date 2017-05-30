Mifan.controller "addCommentCtrl", ($scope, $http) ->


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

      if String(ret) isnt "100000"
        toastType = "warn"

      $scope.toast msg

      if comment.point
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

      comment.feed?.commentList.splice 0, 0, cmt

      comment.feed?.answer.comment_count = comment.feed?.answer.comment_count - 0 + 1

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
      comment.getcommentFeed?.commentList = result or []

    replyExpand: (feed, point) ->
      point.expandReply = not point.expandReply


    replyUsername: ""

    reply: (index, feed, point) ->
      cmt = feed.commentList[index]
      username = cmt.user.username

      comment.replyUsername = username
      point.isSendingRpl = yes
      comment.send feed, point, yes

    replyCb: (data) ->







  comment.init()