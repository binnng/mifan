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

    $scope.askQues $scope.quesContent


  $scope.$on "onAskQuesSuccess", (event, msg) ->


    $scope.quesContent = ""
    $scope.isSending = no
    $scope.isSendSucs = yes


    $timeout ->
      $scope.isSendSucs = no
    , 1000