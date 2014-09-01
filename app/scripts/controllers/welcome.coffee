"use strict"

Mifan.controller "welcomeCtrl", [ "$scope", ($scope) ->

  $scope.$on "$viewContentLoaded", -> $scope.$emit "pageChange", "welcome"

  $scope.$watch "email + password", ->
  	$scope.isLoginValid = $scope.email and $scope.password

  # 是不是在登录界面
  $scope.isLoginBox = no

  # 是不是正在登录，等待服务器返回登录状态
  $scope.isLoging = no
  $scope.isReging = no

  $scope.toggleLogin = -> $scope.isLoginBox = !$scope.isLoginBox

  $scope.loginSubmit = ->
  	$scope.isLoging = yes

  $scope.regSubmit = ->
  	$scope.isReging = yes
  	
	  

  no

]