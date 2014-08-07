"use strict"

# 顶层的业务ctrl，控制整站
# 比如用户信息等

Mifan.controller "rootCtrl", ($scope, $cookieStore, $http) ->

  WIN = $scope.WIN
  DOC = $scope.DOC
  LOC = $scope.LOC

  API = $scope.API
  IsDebug = $scope.IsDebug

  $scope.page = "home"

  $scope.accessToken = $scope.UID = undefined
  $scope.isLogin = no

  $scope.$on "onLogined", (detail, result) ->
    $scope.isLogin = yes

    $scope.accessToken = result["accesstoken"]

    user = result["user"]
    $scope.UID = user["userid"]

    setUserInfo(user)

    $scope.user.accessToken = accessToken

    $cookieStore.put "mUID", user["userid"]
    $cookieStore.put "mUsername", user["username"]
    $cookieStore.put "mAccessToken", $scope.accessToken

  setUserInfo = (user) ->

    $scope.user.username = user["username"] or ""
    $scope.user.email = user["email"] or ""
    $scope.user.face = user["face"] or ""
    $scope.user.face_60 = user["face_60"] or ""
    $scope.user.face_120 = user["face_120"] or ""
    $scope.user.sex = user["sex"] or "1"
    $scope.user.blog = user["blog"] or ""
    $scope.user.uid = user["userid"] or ""

  getUserInfo = ->

    url = "#{API.userInfo}" + ( if IsDebug then "" else "/#{uid}" ) + "#{$scope.privacyParam}"

    $http.get(url)
      .success(getUserInfoCb)
      .error(getUserInfoErrorCb)

  getUserInfoCb = (data) ->

    ret = data["ret"]

    if ret is "100000"
      user = data["result"]
      setUserInfo(user)

  getUserInfoErrorCb = (data) ->

  $scope.user = {}

  uid = $cookieStore.get "mUID"
  accessToken = $cookieStore.get "mAccessToken"
  username = $cookieStore.get "mUsername"

  if uid and accessToken
    # 已经登录
    $scope.isLogin = yes

    $scope.user.uid = $scope.UID = uid
    $scope.accessToken = accessToken

    # 默认用户设置，请求到用户数据之前的显示
    # 请求到后会被覆盖
    $scope.user.face_60 = $scope.user.face_120 = $scope.DEFAULT_FACE
    $scope.user.username = username

    # 通用的接口鉴权
    $scope.privacyParam = "?access_token=#{accessToken}&userid=#{uid}"

    getUserInfo()

  $scope.supportNum = "1万"

  # 设置当前页面
  $scope.$on "pageChange", (e, msg) -> $scope.page = msg

  
  # 设置手机侧边栏菜单状态
  $scope.isMMenuOpen = no

  $scope.toggleMMenu = toggleMMenu = -> 
    $scope.isMMenuOpen = not $scope.isMMenuOpen

  $scope.logout = ->
    $scope.user = {}
    $cookieStore.remove "mUID"
    $cookieStore.remove "mAccessToken"
    $scope.isLogin = no

  # 用ng-click="href(url)" 手机设备使用touch，反应速度快于href
  $scope.href = (url, isToggleMmenu) ->
    LOC["href"] = url
    toggleMMenu() if isToggleMmenu

  # 手指碰到页面，滚动1px
  $scope.scroll1Px = -> 
    el =  DOC["getElementById"] "m-wrap"
    el.scrollTop = 1 if el.scrollTop is 0



  

