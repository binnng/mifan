"use strict"
Mifan.controller "headCtrl", ($scope) ->

  $scope.dropdownOpen = no

  $scope.toggleDropdown = -> $scope.dropdownOpen = not $scope.dropdownOpen;

  $scope.support = ->
    alert 1

  $scope.navs = [
    {page: "home", text: "首页"}
    {page: "msg", text: "消息"}
    {page: "me", text: "个人主页"}
    {page: "friend", text: "朋友"}
    # {page: "hot", text: "排行"}
    {page: "square", text: "广场"}
  ]

  $scope.remind = "米饭新增豆瓣登录!"
  $scope.remind = ""




  # 导航三角形
  # $scope.arrowNav = {}

  # $scope.$watch "page", -> 
  
  #   switch $scope.page
  #     when "home"
  #       $scope.arrowNav = left: 23, hide: no
  #     when "msg"
  #       $scope.arrowNav = left: 90, hide: no
  #     when "me"
  #       $scope.arrowNav = left: 176, hide: no
  #     when "friend"
  #       $scope.arrowNav = left: 260, hide: no
  #     else
  #       $scope.arrowNav = left: 0, hide: yes
