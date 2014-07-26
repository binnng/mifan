"use strict"

# 最顶层的ctrl，控制整站
Mifan.controller "rootCtrl", ($scope) ->

  # 设备
  $scope.ua =
    iphone: IsIPhone
    ipad: IsIPad
    ios: IsIOS

    android: IsAndroid

    weixin: IsWeixin

    mobile: IsTouch

    chrome: IsChrome
    ie: IsIE


  $scope.currentPage = "home"

  $scope.username = ""
  $scope.supportNum = "1万"

  # 设置当前页面
  $scope.$on "pageChange", (e, msg) -> $scope.currentPage = msg

  no
