"use strict"

Mifan.controller "loginCtrl", ($scope) ->

  $scope.$on "$viewContentLoaded", -> $scope.$emit "pageChange", "login"

  $scope.$watch "email + password", ->
    $scope.isLogValid = $scope.email and $scope.password

  # 是不是正在登录，等待服务器返回登录状态
  $scope.isLoging = no

  $scope.onSubmit = ->
    $scope.isLoging = yes