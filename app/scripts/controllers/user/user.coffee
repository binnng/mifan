"use strict"
Mifan.controller "userCtrl", ($scope, $timeout, $http, $routeParams) ->

  userid = $routeParams.id

  return LOC["href"] = "#!/me" if $scope.UID is userid

  $scope.$on "$viewContentLoaded", -> $scope.$emit "pageChange", "user"

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

  user = 
    init: ->
      user.getMyAsk()
      $timeout user.getMyAnswer, 500

      $scope.myAskMsg = $scope.myAnswerMsg = $scope.myLoveMsg = ""
      $scope.myAsk = $scope.myAnswer = $scope.myLove = []
      $scope.myAskMore = $scope.myAnswerMore = $scope.myLoveMore = no

      $scope.followed = no

    getMyAsk: ->
      api = "#{API.myask}#{$scope.privacyParamDir}"
      api = API.myask if IsDebug

      $http.get(api).success user.getMyAskCb

    getMyAskCb: (data) ->
      if String(data.msg) is "ok"
        $scope.myAsk = data.result or []
      else
        $scope.myAskMsg = data.msg

    getMyAnswer: ->
      api = "#{API.myanswer}#{$scope.privacyParamDir}"
      api = API.myanswer if IsDebug

      $http.get(api).success user.getMyAnswerCb

    getMyAnswerCb: (data) ->
      if String(data.msg) is "ok"
        $scope.myAnswer = data.result or []
      else
        $scope.myAnswerMsg = data.msg


  user.init()


  # 向TA提问
  $scope.askHim = () ->
    $scope.showAskBox = yes