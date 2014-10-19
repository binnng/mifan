"use strict"
Mifan.controller "meCtrl", ($scope, $timeout, $http) ->
  
  $scope.$on "$viewContentLoaded", -> $scope.$emit "pageChange", "me"

 	legalFeedTypes = [
    "ask"
    "answer"
    "love"
  ]

  $scope.feedType = "ask"

  # 加载更多
  $scope.loadingMore = ->
    $scope.isLoading = yes

  $scope.switchFeed = (type) ->
    type = type or "ask"
    
    $scope.feedType = type
    $scope.isLoading = no

  $scope.profile = $scope.user

  me = 
    init: ->
      me.getMyAsk()
      $timeout me.getMyAnswer, 300
      $timeout me.getMyLove, 600

      $scope.myAskMsg = $scope.myAnswerMsg = $scope.myLoveMsg = ""
      $scope.myAsk = $scope.myAnswer = $scope.myLove = []
      $scope.myAskMore = $scope.myAnswerMore = $scope.myLoveMore = no

      $scope.myself = yes

    feedWatcher: (feed = "ask")->

    getMyAsk: ->
      api = "#{API.myask}#{$scope.privacyParamDir}"
      api = API.myask if IsDebug

      $http.get(api).success me.getMyAskCb

    getMyAskCb: (data) ->
      if String(data.msg) is "ok"
        $scope.myAsk = data.result or []
      else
        $scope.myAskMsg = data.msg

    getMyAnswer: ->
      api = "#{API.myanswer}#{$scope.privacyParamDir}"
      api = API.myanswer if IsDebug

      $http.get(api).success me.getMyAnswerCb

    getMyAnswerCb: (data) ->
      if String(data.msg) is "ok"
        $scope.myAnswer = data.result or []
      else
        $scope.myAnswerMsg = data.msg

    getMyLove: ->




  me.init()