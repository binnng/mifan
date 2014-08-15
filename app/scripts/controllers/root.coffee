"use strict"

# 顶层的业务ctrl，控制整站
# 比如用户信息等

Mifan.controller "rootCtrl", ($scope, $cookieStore, $http, $timeout, $storage) ->

  WIN = $scope.WIN
  DOC = $scope.DOC
  LOC = $scope.LOC
  BODY = $scope.BODY

  API = $scope.API
  IsDebug = $scope.IsDebug

  IsWebapp = $scope.IsWebapp

  $storage.put = $storage.set

  # 存储信息
  # ios webapp 状态不能存cookie，只能用localstorage存
  store = if IsWebapp then $storage else $cookieStore

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

    store.put "mUID", user["userid"]
    store.put "mUsername", user["username"]
    store.put "mAccessToken", $scope.accessToken


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

  uid = store.get "mUID"
  accessToken = store.get "mAccessToken"
  username = store.get "mUsername"

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


  # 设置手机交互输入内容弹出状态
  $scope.isMDesignOpen = no
  $scope.isMDesignOpenMask = no

  $scope.toggleMDesign = toggleMDesign = (type) -> 


    if $scope.isMDesignOpen
      $scope.isMDesignOpenMask = not $scope.isMDesignOpenMask

      $timeout ->
        $scope.isMDesignOpen = not $scope.isMDesignOpen
      , 200
    else
      $scope.isMDesignOpen = not $scope.isMDesignOpen

      $timeout ->
        $scope.isMDesignOpenMask = not $scope.isMDesignOpenMask
      , 200

    toggleMBill() if $scope.isMBillOpen

    # 如果打开mDesign
    # 广播到 mDesignCtrl 里设置展示类型
    $scope.$broadcast "setMDesignType", type if type and $scope.isMDesignOpen

    # 如果关闭 mDesign，取消内容发送
    $scope.$broadcast "cancelMDesingSending" if not $scope.isMDesignOpen

  # 设置手机菜单弹出状态
  $scope.isMBillOpen = no
  $scope.isMBillOpenMask = no

  $scope.toggleMBill = toggleMBill = (type) -> 

    if $scope.isMBillOpen
      $scope.isMBillOpenMask = not $scope.isMBillOpenMask
    
      $timeout ->
        $scope.isMBillOpen = not $scope.isMBillOpen
      , 200
    else
      $scope.isMBillOpen = not $scope.isMBillOpen
    
      $timeout ->
        $scope.isMBillOpenMask = not $scope.isMBillOpenMask
      , 100




  $scope.logout = ->
    $scope.user = {}
    $cookieStore.remove "mUID"
    $cookieStore.remove "mAccessToken"
    $scope.isLogin = no

  elMwrap =  DOC["getElementById"] "m-wrap"

  # 手指碰到页面，滚动1px
  $scope.scrollBody1Px = -> 
    elMwrap["scrollTop"] = 1 if elMwrap["scrollTop"] is 0

  # 返回顶部
  $scope.backToTop = (isM)->
    (if isM then elMwrap else BODY)["scrollTop"] = 0



  # 用ng-click="href(url)" 手机设备使用touch，反应速度快于href
  # $scope.href = (url, isToggleMmenu) ->
  #   LOC["href"] = url
  #   toggleMMenu() if isToggleMmenu

  # 刷新m-menu
  # refreshMMenu = -> $scope.$broadcast "refreshMMenu"

  # 会造成死循环
  # $broadcast 也会向自身广播
  # $scope.$on "refreshMMenu", refreshMMenu



  

