"use strict"
angular.module("mifan").controller "headCtrl", ($scope) ->
  $scope.currentPage = "home"

  $scope.username = "老婆婆"
  $scope.supportNum = "1万"

  $scope.isDropdownOpen = no

  $scope.support = ->
    alert 1

  no
