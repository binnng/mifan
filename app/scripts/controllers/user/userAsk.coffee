Mifan.controller "userAskCtrl", ($scope, $timeout, $http, $debug, $routeParams) ->

  # 向TA提问
  $scope.quesContent = ""

  userid = $routeParams.id

  $scope.send = ->
    $scope.isSending = yes
    $scope.askQues 
      content: $scope.quesContent
      foruser: userid

  $scope.$on "onAskQuesSuccess", (event, msg) ->
    $scope.quesContent = ""
    $scope.isSending = no
    $scope.isSendSucs = yes

    $timeout ->
      $scope.isSendSucs = $scope.showAskBox = no
    , 1000

    $scope.toast "提问成功！"

  $scope.$on "onAskQuesFail", (event, msg) -> 
    $scope.toast msg.msg
    $scope.isSending = no
    $timeout ->
      $scope.isSendSucs = no
    , 1000