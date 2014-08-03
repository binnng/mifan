"use strict"

# 最顶层的CTRL
# 保存常量

Mifan.controller "globalCtrl", ($scope) ->

  DOC = document
  WIN = window
  LOC = location
  BODY = DOC['body']

  ###
  设备是否支持触摸事件
  这里使用WIN.hasOwnProperty('ontouchend')在Android上会得到错误的结果
  @type {boolean}
  ###
  IsTouch = "ontouchend" of WIN

  NA = WIN.navigator

  UA = NA.userAgent

  # HTC Flyer平板的UA字符串中不包含Android关键词
  IsAndroid = (/Android|HTC/i.test(UA) or /Linux/i.test(NA.platform + "")) 

  IsIPad = not IsAndroid and /iPad/i.test(UA)

  IsIPhone = not IsAndroid and /iPod|iPhone/i.test(UA)

  IsIOS = IsIPad or IsIPhone

  IsWindowsPhone = /Windows Phone/i.test(UA)

  IsBlackBerry = /BB10|BlackBerry/i.test(UA)

  IsIEMobile = /IEMobile/i.test(UA)
  IsIE = !!DOC.all
  IsWeixin = /MicroMessenger/i.test(UA)
  IsChrome = !!WIN['chrome']

  NG = WIN['angular']

  $scope.WIN = WIN
  $scope.DOC = DOC
  $scope.LOC = LOC
  $scope.BODY = BODY


  # 设备
  $scope.IsIPhone = IsIPhone
  $scope.IsIPad = IsIPad
  $scope.IsIOS = IsIOS

  $scope.IsAndroid = IsAndroid

  $scope.IsIEMobile = IsIEMobile

  $scope.IsWeixin = IsWeixin

  $scope.IsTouch = $scope.IsMobile = IsTouch

  $scope.IsChrome = IsChrome
  $scope.IsIE = IsIE


  IsDebug = LOC["port"] is "9000"

  $scope.IsDebug = IsDebug


  BASE_API_PATH = "/mifan/service/index.php"

  $scope.API = 
    user: "#{BASE_API_PATH}/user/usersession/user"
    userInfo: "#{BASE_API_PATH}/user/userinfo/user/id" # 1

  if IsDebug
    BASE_API_PATH = "/data"

    $scope.API = 
      user: "#{BASE_API_PATH}/user.json"
      userInfo: "#{BASE_API_PATH}/user-info.json"

  $scope.DEFAULT_FACE = "http://mifan.us/public/images/user_normal.jpg"






