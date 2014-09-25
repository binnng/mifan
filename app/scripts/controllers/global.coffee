"use strict"

# 最顶层的CTRL
# 保存常量

Mifan.controller "globalCtrl", ($scope) ->

  $scope.WIN = WIN
  $scope.DOC = DOC
  $scope.LOC = LOC
  $scope.BODY = BODY

  $scope.API = API


  # 设备
  $scope.IsIPhone = IsIPhone
  $scope.IsIPad = IsIPad
  $scope.IsIOS = IsIOS

  $scope.IsAndroid = IsAndroid
  $scope.IsAndroidPad = IsAndroidPad

  $scope.IsIEMobile = IsIEMobile

  $scope.IsWeixin = IsWeixin

  $scope.IsTouch = $scope.IsMobile = IsTouch

  $scope.IsChrome = IsChrome
  $scope.IsIE = IsIE

  $scope.IsPhone = IsPhone
  $scope.IsWebapp = IsWebapp


  $scope.DEFAULT_FACE = "http://mifan.us/public/images/user_normal.jpg"






