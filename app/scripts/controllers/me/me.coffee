"use strict"
Mifan.controller "meCtrl", ($scope, $timeout, $http) ->
  
  $scope.$on "$viewContentLoaded", -> $scope.$emit "pageChange", "me"

 	legalFeedTypes = [
    "ask"
    "answer"
    "love"
  ]

  $scope.feedType = "ask"

  $scope.ta = "我"

  # 加载更多
  $scope.loadingMore = ->
    $scope.isLoading = yes

  $scope.switchFeed = (type) ->
    type = type or "ask"

    return no if type is me.curType
    
    $scope.feedType = type
    $scope.isLoading = no
    $scope.dataLoaded = no

    $scope.$emit "onClearPaginationData"

    me.curType = type

    switch type
      when "answer"
        me.getMyAnswer(1)
        $scope.getPage = me.getMyAnswer

      when "love"
        me.getMyLove(1)
        $scope.getPage = me.getMyLove

      else
        me.getMyAsk(1)
        $scope.getPage = me.getMyAsk

      
    

  $scope.profile = $scope.user

  me = 
    init: ->

      $scope.myAskMsg = $scope.myAnswerMsg = $scope.myLoveMsg = ""
      $scope.myAsk = $scope.myAnswer = $scope.myLove = []
      $scope.myAskMore = $scope.myAnswerMore = $scope.myLoveMore = no

      $scope.myself = yes

      $scope.switchFeed ""

    feedWatcher: (feed = "ask")->

    curType: ""

    getMyAsk: (page = 1)->
      api = "#{API.myask}#{$scope.privacyParamDir}/page/#{page}"
      api = API.myask if IsDebug

      $http.get(api).success me.getMyAskCb

      $scope.$emit "onPaginationStartChange", page

    getMyAskCb: (data) ->
      if String(data.msg) is "ok"
        $scope.myAsk = data.result['list'] or []
      else
        $scope.myAskMsg = data.msg

      $scope.$emit "onPaginationGeted", data['result']['page']

      $scope.dataLoaded = yes


    getMyAnswer: (page = 1)->
      api = "#{API.myanswer}#{$scope.privacyParamDir}/page/#{page}"
      api = API.myanswer if IsDebug

      $http.get(api).success me.getMyAnswerCb

      $scope.$emit "onPaginationStartChange", page

    getMyAnswerCb: (data) ->
      if String(data.msg) is "ok"
        $scope.myAnswer = data.result['list'] or []

      else
        $scope.myAnswerMsg = data.msg

      $scope.$emit "onPaginationGeted", data['result']['page']

      $scope.dataLoaded = yes


    getMyLove: (page = 1)->
      api = "#{API.mylove}#{$scope.privacyParamDir}/page/#{page}"
      api = API.mylove if IsDebug

      $http.get(api).success me.getMyLoveCb

      $scope.$emit "onPaginationStartChange", page

    getMyLoveCb: (data) ->
      if String(data.msg) is "ok"
        $scope.myLove = data.result['list'] or []

      else
        $scope.myLoveMsg = data.msg

      $scope.$emit "onPaginationGeted", data['result']['page']

      $scope.dataLoaded = yes





  me.init()