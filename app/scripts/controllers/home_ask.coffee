"use strict"

Mifan.controller "homeAskCtrl", ($scope) ->

  $scope.askQuesConent = ""
  $scope.bgUrl = "images/beijing01.jpg"
  $scope.avatarUrl = "http://tp4.sinaimg.cn/2005321383/180/5698650002/1"

  $scope.isSending = no

  $scope.onFocus = -> $scope.onInputing = yes
  $scope.onBlur = (force) -> 
  	if force or $scope.askQuesConent is "" 
  		$scope.onInputing = no 

  $scope.send = ->
  	$scope.isSending = yes