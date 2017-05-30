Mifan.controller "addLoveCtrl", ($scope, $http) ->


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
        if loveAns.feed
          loveAns.feed.love.iflove = 1
          loveAns.feed.answer.digg = result
          
        msg = "喜欢成功"
      else
        toastType = "warn"

      $scope.toast msg, toastType
        
  loveAns.init()