Mifan.controller "friendCtrl", ($scope, $routeParams, $location) ->

  # 是不是他人朋友页面
  userid = $routeParams.id or null

  # 是不是自己
  $scope.myself = myself = if not userid then yes else ($scope.UID is userid)

  # 是不是粉丝页面
  isFansPage = $location.$$url.indexOf("fans") > -1

  $scope.$on "$viewContentLoaded", -> $scope.$emit "pageChange", "friend"

  $scope.feedType = if isFansPage then "fans" else "follow"

  $scope.switchFeed = switchFeed = (type = "follow") -> 

    return no if type is friend.curType
    
    $scope.feedType = type
    $scope.isLoading = no
    $scope.dataLoaded = no
    $scope.dataLists = null

    $scope.$emit "onClearPaginationData"

    friend.curType = type

    switch type
      when "follow"
        friend.getFollow 1
        $scope.getPage = friend.getFollow

      else
        friend.getFans 1
        $scope.getPage = friend.getFans

  setFollowBtn = (iffollow) ->
    iffollow = iffollow or 0
    followBtn = {}
    switch iffollow - 0
      when 0
        followBtn = 
          txt: ""
          cls: "success"
      when 1
        followBtn = 
          txt: "取消"
          cls: "warning"
      when 2
        followBtn = 
          txt: "互相"
          cls: "warning"

    followBtn.txt += "关注"
    followBtn


  $scope.ta = if myself then "我" else "TA"

  friend = 

    init: ->

      $scope.$on "onGetUserFollowsCb", (e, data) ->
        friend.getFollowCb data

      $scope.$on "onGetUserFansCb", (e, data) ->
        friend.getFansCb data

      switchFeed $scope.feedType

      $scope.theuser = userid


    getFollow: (page = 1) ->
      $scope.$emit "onPaginationStartChange", page

      uid = if myself then $scope.UID else userid

      $scope.$emit "onGetUserFollows", page: page, uid: uid


    getFollowCb: (data) ->

      {ret, msg, result}  = data

      if result and result.page
        dataLists = result["list"]

        for data in dataLists
          data.followBtn = setFollowBtn data.iffollow

        $scope.dataLists = dataLists

        pageData = result["page"]
        $scope.$emit "onPaginationGeted", pageData if pageData

      else
        $scope.errorMsg = msg

      $scope.dataLoaded = yes


    getFans: (page = 1) ->
      $scope.$emit "onPaginationStartChange", page

      uid = if myself then $scope.UID else userid
      
      $scope.$emit "onGetUserFans", page: page, uid: uid

    getFansCb: (data) ->

      {ret, msg, result}  = data

      if result and result.page
        dataLists = result["list"]

        for data in dataLists
          data.followBtn = setFollowBtn data.iffollow

        $scope.dataLists = dataLists

        pageData = result["page"]
        $scope.$emit "onPaginationGeted", pageData if pageData

      else
        $scope.errorMsg = msg

      $scope.dataLoaded = yes



  friend.init()