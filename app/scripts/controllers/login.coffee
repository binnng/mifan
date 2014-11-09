"use strict"

Mifan.controller "loginCtrl", ($scope, $http, $timeout, $location) ->

  API = $scope.API
  $scope.$on "$viewContentLoaded", -> $scope.$emit "pageChange", "login"


  $scope.error = null

  userLoginSuccessCb = (data, status) ->
    ###
    {
      "msg": "密码错误！",
      "ret": "104003"
    }

    {
      "msg": "Email不存在，你可能还没有注册！",
      "ret": "104002"
    }

    {
      "msg": "OK",
      "ret": "100000",
      "result": {}
    }
    ###

    ret = data["ret"]

    # 成功
    if ret is "100000"
      
      result = data["result"]

      # 向root发送登录事件
      $scope.$emit "onLogined", result


    # 密码错误
    else if ret is "104003"
      $scope.error = type: "password", msg: "密码错误 :("

    # 用户名错误
    else if ret is "104002"
      $scope.error = type: "username", msg: "用户名不存在 T_T"


    if $scope.error
      $timeout ->
        $scope.error = null
      , 3000

    
    $scope.isLoging = no

  userLoginErrorCb = (data, status) ->

    ret = data["ret"]
    $scope.isLoging = no


  userLogin = ->

    $scope.isLoging = yes

    $http(
      method: if IsDebug then "GET" else "POST"
      url: API.user
      data:
        user_email: $scope.email
        user_password: $scope.password
    )
    .success(userLoginSuccessCb)
    .error(userLoginErrorCb)


  $scope.$watch "email + password", ->
    $scope.isLogValid = $scope.email and $scope.password

  # 是不是正在登录，等待服务器返回登录状态
  $scope.isLoging = no

  $scope.onSubmit = ->

    userLogin() if $scope.email and $scope.password


  SNS = 
    init: ->
      $scope.loginweibo = SNS.weibo

      SNS.weiboLoginSuccess() if SNS.getWeiboLoginCode()

    weibo: ->
      return no if $scope.isWeiboLoging

      $scope.isWeiboLoging = yes

      api = "#{API.weiboLogin}"
      api = API.weiboLogin if IsDebug

      $http.get(api).success SNS.weiboCb


    weiboCb: (data)->
      $scope.isWeiboLoging = no
      {ret, msg, result} = data
      LOC["href"] = result

    getWeiboLoginCode: ->
      code = $location.$$search?["code"]
      SNS.weiboLoginCode = code

      code

    weiboLoginSuccess: ->
      api = if IsDebug then API.weiboLoginCb else "#{API.weiboLoginCb}?code=#{SNS.weiboLoginCode}"
      $http.get(api).success SNS.weiboLoginSuccessCb

      $scope.isWeiboLoging = yes

    weiboLoginSuccessCb: (data) ->
      {ret, msg, result} = data
      $scope.isWeiboLoging = no
      $location.$$search = null

      if result
        $scope.$emit "onLogined", result
      else
        $scope.toast msg, "warn"






  SNS.init()



