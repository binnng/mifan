"use strict"
Mifan.controller "rootCtrl", ($scope) ->
  $scope.currentPage = "home"

  $scope.username = ""
  $scope.supportNum = "1万"

  $scope.dropdownOpen = no

  $scope.toggleDropdown = -> $scope.dropdownOpen = not $scope.dropdownOpen;

  $scope.support = ->
    alert 1

  # 设置当前页面
  $scope.$on "pageChange", (e, msg) -> $scope.currentPage = msg

  no
