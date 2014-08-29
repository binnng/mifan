"use strict"

# 最顶层的CTRL
# 保存常量

Mifan.controller "globalCtrl", ($scope) ->

  $scope.WIN = WIN
  $scope.DOC = DOC
  $scope.LOC = LOC
  $scope.BODY = BODY


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




  BASE_API_PATH = "/mifan/service/index.php"

  $scope.API = 
    user: "/user/usersession/user"
    userInfo: "/user/userinfo/user/id" # 1
    ask: "/ask/askinfo/ask"
    news: "/feed/feedinfo/feeds"

  if IsDebug
    BASE_API_PATH = "/data"

    $scope.API = 
      user: "/user.json"
      userInfo: "/user-info.json"
      ask: "/ask.json"
      news: "/news.json"

  $scope.API[api] = "#{BASE_API_PATH}#{$scope.API[api]}" for api of $scope.API


  $scope.DEFAULT_FACE = "http://mifan.us/public/images/user_normal.jpg"






