"use strict"

# 顶层的业务ctrl，控制整站
# 比如用户信息等

Mifan.controller "rootCtrl", ($scope, $cookieStore, $http, $timeout, $storage, $emoji, $cacheFactory, $extend, $location, $debug) ->

  API = $scope.API

  $storage.put = $storage.set

  # 存储信息
  # ios webapp 状态不能存cookie，只能用localstorage存
  store = if IsWebapp then $storage else $cookieStore

  $scope.supportNum = "1万"

  ###
  用户信息，用户操作的方法
  ###
  User = 

    init: ->

      $scope.user = {}
      $scope.accessToken = $scope.UID = $scope.username = undefined

      $scope.isLogin = no
      $scope.$on "onLogined", User.onLoginCb

      $scope.User = User

      User.getLocal()

    set: (user) ->
      $extend $scope.user, user



    getRemote: ->

      uid = $scope.user.uid

      url = [
        "#{API.userInfo}"
        ( if IsDebug then "" else "/#{uid}" )
        "#{$scope.privacyParam}"
        "&uid=#{uid}"
      ].join ""

      $http.get(url).success(User.getRemoteCb).error(User.getRemoteErrorCb)


    getRemoteCb: (data) ->

      ret = data["ret"]

      if String(ret) is "100000"
        user = data["result"]

        User.set user

        $scope.isLogin = yes

        $scope.$broadcast "getHomeNews"
      else
        User.onOutOfDate()

    getRemoteErrorCb: (data) ->

    isLocalLogin: no

    getLocal: ->
      uid = store.get "mUID"
      accessToken = store.get "mAccessToken"

      if uid and accessToken
        User.getLocalCb(uid, accessToken)
      else
        User.login()
    
    getLocalCb: (uid, accessToken) ->
      User.isLocalLogin = yes

      username = store.get "mUsername"
      $scope.user.uid = $scope.UID = uid

      # 默认用户设置，请求到用户数据之前的显示
      # 请求到后会被覆盖
      $scope.user.face_60 = $scope.user.face_120 = $scope.DEFAULT_FACE
      $scope.user.username = $scope.username = username

      $scope.accessToken = accessToken

      User.setPrivacy()

      User.getRemote()

    setPrivacy: ->

      accessToken = $scope.accessToken
      uid = $scope.UID

      # 通用的接口鉴权
      $scope.privacyParam = "?access_token=#{accessToken}&userid=#{uid}"
      $scope.privacyParamDir = "/access_token/#{accessToken}/userid/#{uid}"


    store: (user) ->

      store.put "mUID", user["userid"]
      store.put "mUsername", user["username"]
      store.put "mAccessToken", $scope.accessToken


    remove: ->
      store.remove "mUID"
      store.remove "mUsername"
      store.remove "mAccessToken"

    onLoginCb: (event, result) ->
      $scope.isLogin = yes

      accessToken = $scope.accessToken = result["accesstoken"]

      user = result["user"]
      $scope.username = user["username"]
      $scope.UID = user["userid"]

      $scope.user.accessToken = accessToken

      User.set user
      User.store user

      User.setPrivacy()

      $location.path "/"

      #LOC["reload"]()

    # 登录过期
    onOutOfDate: ->
      User.remove()

      $scope.isLogin = no

      User.login()

    logout: ->
      $scope.user = {}
      $cookieStore.remove "mUID"
      $cookieStore.remove "mAccessToken"
      $scope.isLogin = no

      $timeout User.login, 200

    login: ->
      $location.path "login" unless $location.path().match /login/

  User.init()



  ###
  页面切换，页面操作
  ###
  elMwrap =  DOC["getElementById"] "m-wrap"

  Page = 

    init: ->
      $scope.page = "home"

      $scope.scrollBody1Px = Page.scrollBody1Px

      # 返回顶部
      $scope.backToTop = Page.onBackToTop

      # 设置当前页面
      $scope.$on "pageChange", Page.onPageChangeCb

      $scope.logout = User.logout

      $scope.Page = Page

      # 滚动页面到顶部
      $scope.$on "onScrollTop", (e, msg) -> Page.onBackToTop()

    onPageChangeCb: (event, msg) ->
      $scope.page = msg
      elMwrap["scrollTop"] = 1

      # 清除分页
      Pagination.clear()

      # if "login|register|square".indexOf($scope.page) < 0
      #   User.login() unless $scope.isLogin

    onBackToTop: (isM)->
      (if isM then elMwrap else BODY)["scrollTop"] = 0
    
    # 手指碰到页面，滚动1px
    scrollBody1Px: -> 
      elMwrap["scrollTop"] = 1 if elMwrap["scrollTop"] is 0

  Page.init()


  ###
  移动用户侧边栏菜单
  ###
  MMenu = 
    init: ->
  
      # 设置手机侧边栏菜单状态
      $scope.isMMenuOpen = no

      $scope.toggleMMenu = MMenu.toggle

      $scope.MMenu = MMenu

    toggle: ->
      $scope.isMMenuOpen = not $scope.isMMenuOpen


  MMenu.init()

  ###
  移动全屏输入框
  ###
  MDesign = 
    init: ->
      $scope.isMDesignOpen = no
      $scope.isMDesignOpenMask = no

      $scope.toggleMDesign = MDesign.toggle 

      $scope.$on "onMDesignSend", MDesign.onSend

    toggle: (type) -> 
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

      MBill.toggle() if $scope.isMBillOpen

      # 如果打开mDesign
      # 广播到 mDesignCtrl 里设置展示类型
      $scope.$broadcast "setMDesignType", type if type and $scope.isMDesignOpen

      # 如果关闭 mDesign，取消内容发送
      $scope.$broadcast "cancelMDesingSending" if not $scope.isMDesignOpen

    onSend: (event, msg) ->

      type = msg.type
      content = msg.content

      switch type
        when "ask"
          Ask.ask content

    onOpen: ->

    onClose: ->

  MDesign.init()

  ###
  移动底部弹出交互菜单
  ###
  MBill = 
    init: ->
      $scope.isMBillOpen = no
      $scope.isMBillOpenMask = no

      $scope.toggleMBill = MBill.toggle


    toggle: (billList) -> 

      if $scope.isMBillOpen
        $scope.isMBillOpenMask = not $scope.isMBillOpenMask
      
        $timeout ->
          $scope.isMBillOpen = not $scope.isMBillOpen
        , 200
      else

        $scope.$broadcast "setBillList", billList

        $scope.isMBillOpen = not $scope.isMBillOpen
      
        $timeout ->
          $scope.isMBillOpenMask = not $scope.isMBillOpenMask
        , 100

  MBill.init()




  ###
  提问
  ###
  Ask = 
    init: ->
      $scope.askQues = Ask.ask

    ask: (data) ->

      url = "#{API.ask}#{$scope.privacyParamDir}"
      url = API.ask if IsDebug

      query = content: data.content
      query.foruser = data.foruser if data.foruser

      (if IsDebug then $http.get else $http.post)(url,
        query
      ).success Ask.askCb

    askCb: (data)->
      ret = data["ret"]

      if String(ret) is "100000"
        $scope.$broadcast "onAskQuesSuccess", queId: data["result"]
        $scope.$broadcast "onMDesignSendSuccess"

      else
        $scope.$broadcast "onAskQuesFail", msg: data.msg

  Ask.init()


  # 用ng-click="href(url)" 手机设备使用touch，反应速度快于href
  # $scope.href = (url, isToggleMmenu) ->
  #   LOC["href"] = url
  #   toggleMMenu() if isToggleMmenu

  # 刷新m-menu
  # refreshMMenu = -> $scope.$broadcast "refreshMMenu"

  # 会造成死循环
  # $broadcast 也会向自身广播
  # $scope.$on "refreshMMenu", refreshMMenu


  #$emoji.setEmojiPath "images/emoji/"

  ###
  缓存的配置
  ###
  Cache = 

    init: ->
      $httpDefaultCache = $cacheFactory.get $http
      lruCache = $cacheFactory "lruCache", capacity: 8

  Cache.init()

  Notification = 
    init: ->
      Notification.get()

    time: 0

    get: ->
      api = if IsDebug then API.notice else "#{API.notice}#{$scope.privacyParamDir}"

      $http.get(api).success Notification.cb

      Notification.time++

    cb: (data)->
      if data.msg is "ok"
        $scope.msgCount = data.result or 0

      $timeout Notification.get, 30000

  Notification.init()

  # 弹出的提示信息
  Toast = 
    init: ->
      $scope.toast = Toast.toast
      $scope.Toast = Toast
    text: ""

    isShow: no

    type: "primary"

    toast: (msg, type) ->
      Toast.text = msg
      Toast.isShow = yes
      Toast.type = type or "success"

      $timeout (-> Toast.isShow = no), 3000

  Toast.init()

  # 关注和取消关注
  Follow = 
    init: ->
      $scope.$on "follow", (event, data) ->
        Follow.follow data.userid

      $scope.$on "unfollow", (event, data) -> 
        Follow.unfollow data.userid

    send: (api, cb) ->
      (if IsDebug then $http.get else $http.post)(api).success cb

    follow: (uid) ->
      api = "#{API.follow}#{$scope.privacyParamDir}/userid_follow/#{uid}"
      api = API.follow if IsDebug

      Follow.send api, Follow.followCb

    followCb: (data) ->
      $scope.$broadcast "followCb", data

    unfollow: (uid) ->
      api = "#{API.unfollow}#{$scope.privacyParamDir}/userid_follow/#{uid}"
      api = API.unfollow if IsDebug

      Follow.send api, Follow.unfollowCb

    unfollowCb: (data) ->
      $scope.$broadcast "unfollowCb", data

  Follow.init()

  # 喜欢回答
  LoveAns = 
    init: ->
      $scope.loveAns = LoveAns.send
      $scope.$on "loveans", (event, data) -> LoveAns.send data

    feed: null

    send: (data) ->
      api = "#{API.loveanswer}#{$scope.privacyParamDir}"
      api = API.loveanswer if IsDebug
      query = data

      (if IsDebug then $http.get else $http.post)(api, query).success LoveAns.sendCb

    sendCb: (data) -> $scope.$broadcast "loveansCb", data

  LoveAns.init()

  # 回答问题
  Ans = 
    init: ->
      $scope.Ans = Ans.send
      $scope.$on "ans", (event, data) ->
        Ans.send data

    send: (data) ->

      api = "#{API.answer}#{$scope.privacyParamDir}"
      api = API.answer if IsDebug

      query = 
        askid: data.askid
        content: data.content

      (if IsDebug then $http.get else $http.post)(api, query).success (data) ->
        Ans.sendCb data

    sendCb: (data) -> $scope.$broadcast "ansCb", data

  Ans.init()

  # 获取他人用户信息
  getUserInfo = 
    init: ->
      $scope.$on "getUserInfo", (e, data) -> getUserInfo.get data

    get: (data) ->
      uid = data.uid

      api = [
        "#{API.userInfo}"
        ( if IsDebug then "" else "/#{uid}" )
        "#{$scope.privacyParam}"
        "&uid=#{uid}"
      ].join ""

      $http.get(api).success getUserInfo.getCb

    getCb: (data) -> 
      {msg, result} = data

      $scope.$broadcast "getUserInfoCb", data

  getUserInfo.init()


  # 评论
  Comment = 
    init: ->
      $scope.$on "comment", (e, data) -> Comment.send data
      $scope.$on "getcomment", (e, data) -> Comment.get data

    send: (data) ->
      api = "#{API.comment}#{$scope.privacyParamDir}"
      api = API.comment if IsDebug


      (if IsDebug then $http.get else $http.post)(api, data).success (data) ->
        Comment.sendCb data

    sendCb: (data) ->
      $scope.$broadcast "commentCb", data

    get: (data) ->
      api = "#{API.getComment}#{$scope.privacyParamDir}/answerid/#{data.answerid}"
      api = API.getComment if IsDebug

      $http.get(api).success (data) ->
        Comment.getCb data

    getCb: (data) ->
      $scope.$broadcast "getcommentCb", data

  Comment.init()

  # 分页
  Pagination = 

    init: ->

      $scope.page = {}
      $scope.isPageLoading = no

      $scope.$on "onPaginationStartChange", Pagination.onChange
      $scope.$on "onPaginationGeted", Pagination.set
      $scope.$on "onClearPaginationData", Pagination.clear

    onChange: (event, msg) ->
      $scope.curPage = msg
      $scope.isPageLoading = yes


    curPage: 1

    totalPage: 0

    set: (e, pageData) ->

      curPage = Number pageData['cur_page']
      totalPage = Number pageData['total_page']

      Pagination.curPage = curPage
      Pagination.totalPage = totalPage
      
      $scope.isPageLoading = no
      $scope.curPage = curPage
      $scope.totalPage = totalPage
      $scope.pages = [1..totalPage]

      # 滚动到页面顶部
      Page.onBackToTop()


    clear: ->
      
      $scope.isPageLoading = no
      $scope.curPage = 1
      $scope.totalPage = 0
      $scope.pages = []



  Pagination.init()
      



  

