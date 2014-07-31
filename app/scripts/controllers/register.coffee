"use strict"

Mifan.controller "registerCtrl", ($scope) ->

  $scope.$on "$viewContentLoaded", -> $scope.$emit "pageChange", "register"

  $scope.$watch "email + password", ->
  	$scope.isRegValid = $scope.email and $scope.password

  # 是不是正在登录，等待服务器返回登录状态
  $scope.isReging = no

  $scope.regSubmit = ->
  	$scope.isReging = yes