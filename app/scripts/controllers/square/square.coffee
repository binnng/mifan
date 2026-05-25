Mifan.controller "squareCtrl", ($scope, $http, $random) ->

  $scope.$on "$viewContentLoaded", -> $scope.$emit "pageChange", "square"

  MAX_SQUARE_PAGE = 20


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

  square = 

    init: ->

      square.getNews 1
      square.getUsers 1

      $scope.$emit "onClearPaginationData"

      $scope.refreshFeed = square.refreshFeed
      $scope.refreshUsers = square.refreshUsers


    totalPage: 0

    getNews: (page = 1)->
      api = "#{API.squareask}#{$scope.privacyParamDir}/page/#{page}?type=latest"
      api = API.squareask if IsDebug

      $http.get(api).success square.getNewsCb

    getNewsCb: (data) ->

      {ret, msg, result}  = data

      if msg is "ok"
        $scope.dataLists = dataLists = result['list'] or []

        square.totalPage = result["page"]["total_page"]

        $scope.everyoneAskLists = everyoneAskLists = [dataLists[$random.in [0..dataLists.length - 1]]]

      else
        $scope.errorMsg = msg


      $scope.dataLoaded = yes

    refreshFeed: ->

      max = if square.totalPage > MAX_SQUARE_PAGE then MAX_SQUARE_PAGE else square.totalPage

      page = $random.in [1..max]
      $scope.dataLoaded = no
      #$scope.dataLists = $scope.everyoneAskLists = null

      square.getNews page

    getUsers: (page = 1) ->
      api = "#{API.squareusers}#{$scope.privacyParamDir}/page/#{page}?type=latest"
      api = API.squareusers if IsDebug

      $http.get(api).success square.getUsersCb

    getUsersCb: (data) ->

      {ret, msg, result} = data

      if msg is "ok"
        $scope.userLists = userLists = result["list"] or []
        square.totalUserPage = result["page"]["total_page"]

        #for data in userLists
        #  data.followBtn = setFollowBtn data.iffollow

      else
        $scope.errorMsg = msg

      $scope.userDataLoaded = yes

    refreshUsers: ->

      max = if square.totalUserPage > MAX_SQUARE_PAGE then MAX_SQUARE_PAGE else square.totalUserPage

      page = $random.in [1..max]
      $scope.userDataLoaded = no

      square.getUsers page



  square.init()
