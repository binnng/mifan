"use strict"

Mifan.controller "homeAskCtrl", ($scope, $timeout) ->

  $scope.quesContent = ""
  #$scope.avatarUrl = "http://tp4.sinaimg.cn/2005321383/180/5698650002/1"

  $scope.isSending = no

  # $scope.onFocus = -> $scope.onInputing = yes
  # $scope.onBlur = (force) -> 
  #   if force or $scope.askQuesConent is ""
  #     $scope.onInputing = $scope.isSending = no

  $scope.send = ->
    $scope.isSending = yes

    $scope.askQues
      content: $scope.quesContent

  clearAsk = ->
    $scope.isSending = no
    $timeout ->
      $scope.isSendSucs = no
    , 1000


  $scope.$on "onAskQuesSuccess", (event, msg) ->
    $scope.quesContent = ""
    $scope.isSendSucs = yes
    $scope.toast "提问成功！"

    clearAsk()

  $scope.$on "onAskQuesFail", (event, msg) -> 
    $scope.toast msg.msg, "warn"
    clearAsk()