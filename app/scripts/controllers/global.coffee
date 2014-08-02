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


  # 记录用户信息的cookie名
  $scope.UCNAME = "MifanUser"


  IsDebug = LOC["port"] is "9000"

  $scope.IsDebug = IsDebug



  $scope.API = 
    user: "/mifan/service/index.php?/user/usersession/user"

  if IsDebug
    $scope.API = 
      user: "/data/user.json"






