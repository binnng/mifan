"use strict"
Mifan.controller "headCtrl", ($scope) ->
  $scope.dropdownOpen = no

  $scope.toggleDropdown = -> $scope.dropdownOpen = not $scope.dropdownOpen;

  $scope.support = ->
    alert 1

  # 导航三角形
  $scope.arrowNav = {}

  $scope.$watch "page", -> 
  
    switch $scope.page
      when "home"
        $scope.arrowNav = left: 23, hide: no
      when "msg"
        $scope.arrowNav = left: 90, hide: no
      when "me"
        $scope.arrowNav = left: 176, hide: no
      when "friend"
        $scope.arrowNav = left: 260, hide: no
      else
        $scope.arrowNav = left: 0, hide: yes

  no
