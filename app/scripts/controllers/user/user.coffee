"use strict"
Mifan.controller "userCtrl", ($scope, $timeout, $http, $routeParams, $location) ->

  userid = $routeParams.id

  $scope.myself = $scope.UID is userid

  $scope.$on "$viewContentLoaded", -> $scope.$emit "pageChange", "user"

 	legalFeedTypes = [
    "ask"
    "answer"
    "love"
  ]

  $scope.feedType = "ask"
  $scope.ta = "TA"

  # 加载更多
  $scope.loadingMore = ->
    $scope.isLoading = yes

  $scope.switchFeed = (type) ->
    type = type or "ask"

    return no if type is user.curType
    
    $scope.feedType = type
    $scope.isLoading = no
    $scope.dataLoaded = no

    $scope.$emit "onClearPaginationData"

    user.curType = type

    switch type
      when "answer"
        user.getMyAnswer()
        $scope.getPage = user.getMyAnswer

      when "love"
        user.getMyLove()
        $scope.getPage = user.getMyLove

      else
        user.getMyAsk()
        $scope.getPage = user.getMyAsk

  $scope.profile = null

  user = 
    init: ->

      $scope.myAskMsg = $scope.myAnswerMsg = $scope.myLoveMsg = ""
      $scope.myAsk = $scope.myAnswer = $scope.myLove = []
      $scope.myAskMore = $scope.myAnswerMore = $scope.myLoveMore = no


      $scope.$on "getUserInfoCb", (event, data) -> user.getUserInfoCb data

      $timeout user.getUserInfo, 100
      
      $scope.switchFeed ""

    getMyAsk: (page = 1)->
      api = "#{API.friendAsk}#{$scope.privacyParamDir}/page/#{page}?uid=#{userid}"
      api = API.friendAsk if IsDebug

      $http.get(api).success user.getMyAskCb

      $scope.$emit "onPaginationStartChange", page

    getMyAskCb: (data) ->
      $scope.dataLoaded = yes

      {ret, msg, result} = data


      if String(data.msg) is "ok"
        $scope.myAsk = result?['list'] or []

        $scope.$emit "onPaginationGeted", result['page']


      else
        $scope.errorMsg = msg

    getMyAnswer: (page = 1)->
      api = "#{API.friendAns}#{$scope.privacyParamDir}/page/#{page}?uid=#{userid}"
      api = API.friendAns if IsDebug

      $http.get(api).success user.getMyAnswerCb

      $scope.$emit "onPaginationStartChange", page

    getMyAnswerCb: (data) ->

      {ret, msg, result} = data

      $scope.dataLoaded = yes

      if String(data.msg) is "ok"
        $scope.myAnswer = result?['list'] or []

        $scope.$emit "onPaginationGeted", result['page']


      else
        $scope.errorMsg = msg

    getMyLove: (page = 1) -> 
      api = "#{API.frinedLove}#{$scope.privacyParamDir}/page/#{page}?uid=#{userid}"
      api = API.frinedLove if IsDebug

      $http.get(api).success user.getMyLoveCb

      $scope.$emit "onPaginationStartChange", page

    getMyLoveCb: (data) ->

      {ret, msg, result} = data

      $scope.dataLoaded = yes
      
      if String(data.msg) is "ok"
        $scope.myLove = result?['list'] or []

        $scope.$emit "onPaginationGeted", result['page']


      else
        $scope.errorMsg = msg

    getUserInfo: ->
      $scope.$emit "getUserInfo", uid: userid

    getUserInfoCb: (data) ->
      {msg, ret, result} = data
      
      if String(ret) is "100000"
        $scope.profile = result

        # 0 未关注或自己， 1已关注，2互相关注
        $scope.iffollow = result.iffollow
        follow.setFollowBtn result.iffollow

        if not $scope.myself
          # 1是男 2是女 0是保密
          switch "#{result.sex}"
            when "1"
              $scope.ta = "他"
            when "2"
              $scope.ta = "她"
        else
          $scope.ta = "我"



  user.init()


  # 向TA提问
  $scope.askHim = () ->
    $scope.showAskBox = not $scope.showAskBox


  # 关注和取消关注
  $scope.isFollowSending = no

  follow = 
    init: ->
      $scope.follow = follow.follow
      $scope.unfollow = follow.unfollow

      $scope.$on "followCb", (event, data) -> 
        follow.onFollowCb data
      $scope.$on "unfollowCb", (event, data) -> follow.onUnfollowCb data

      $scope.followFn = -> 
        switch Number $scope.iffollow
          when 0
            follow.follow()
          when 1
            follow.unfollow()
          when 2
            follow.unfollow()

    follow: -> 
      $scope.isFollowSending = yes
      $scope.$emit "follow", userid: userid

    unfollow: -> 
      $scope.isFollowSending = yes
      $scope.$emit "unfollow", userid: userid

    onFollowCb: (data) ->
      {msg, ret, result} = data
      toastType = ""

      msg = "关注成功!" if msg is "ok"

      if String(ret) is "100000"
        $scope.iffollow = result
        follow.setFollowBtn result

        # -0 转换为数字类型
        $scope.profile.count_followed = $scope.profile.count_followed - 0 + 1;

        # 设置自己的关注数
        $scope.user.count_follow  = $scope.user.count_follow - 0 + 1;
      else
        toastType = "warn"

      $scope.toast msg, toastType
      $scope.isFollowSending = no

    onUnfollowCb: (data) ->
      {msg, ret, result} = data
      toastType = ""

      msg = "取消关注成功!" if msg is "ok"

      if String(ret) is "100000"
        $scope.iffollow = result
        follow.setFollowBtn result

        $scope.profile.count_followed -= 1

        # 设置自己的关注数
        $scope.user.count_follow  -= 1;
      else
        toastType = "warn"

      $scope.toast msg, toastType
      $scope.isFollowSending = no

    setFollowBtn: (iffollow) ->
      iffollow = iffollow or 0
      followBtn = {}
      switch Number iffollow
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
      $scope.followBtn = followBtn


  follow.init()








