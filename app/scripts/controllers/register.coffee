"use strict"

Mifan.controller "registerCtrl", ($scope) ->

  $scope.$on "$viewContentLoaded", -> $scope.$emit "pageChange", "register"

  toast = (msg, type, time = 5000) ->
    $scope.toast msg, type, time

  rules = 
    email:
      reg: /^(\w)+(\.\w+)*@(\w)+((\.\w+)+)$/
      tip: "邮箱格式错误"
    pwd:
      reg: /^[\w\~\!\@\#\$\%\^\&\*\(\)\+\`\-\=\[\]\\\{\}\|\;\'\:\"\,\.\/\<\>\?0-9a-zA-z]{6,20}$/
      tip: "密码应该由6-40个英文字母、数字或符号组成"

  validEmail = (email) ->
    rules.email.reg.test email

  validPwd = (pwd) ->
    pwd and rules.pwd.reg.test pwd

  validName = (name) -> !!name

  validInviteCode = (code) -> !!code

  reg = 
    init: ->

      $scope.$watch "email + password + username + invitecode", ->
        $scope.isRegValid = reg.valid()

      # 是不是正在登录，等待服务器返回登录状态
      $scope.isReging = no

      $scope.onSubmit = reg.onSubmit
      $scope.valid = reg.valid

      $scope.$on "onRegCb", (event, data) -> reg.onSubmitCb data

    # needToast 校验完后需要提示么
    valid: (needToast) ->
      {email, password, username, invitecode} = $scope

      flag = no

      base = !!(email and password and username and invitecode)

      isEmailOk = email and validEmail(email)
      isNameOk = username and validName(username)
      isPwdOk = password and validPwd(password)
      isCodeOk = invitecode and validInviteCode(invitecode)

      if isEmailOk and isNameOk and isPwdOk and isCodeOk
        flag = yes

      else
        flag = no

        if needToast
          if not isEmailOk
            toast rules.email.tip, "error" if email

          if not isPwdOk
            toast rules.pwd.tip, "error" if password

      flag


    onSubmit: ->
      $scope.isReging = yes

      {email, password, username, invitecode} = $scope

      $scope.$emit "onReg", 
        email: email
        password: password
        username: username
        invitecode: invitecode

    onSubmitCb: (data) ->
      {ret, msg, result} = data
      isSuccess = no

      $scope.isReging = no

      if String(ret) is "100000"
        $scope.$emit "onRegSuccess", result

        toast "注册成功！", "success"

      else
        toast msg, "error" if msg



  reg.init()