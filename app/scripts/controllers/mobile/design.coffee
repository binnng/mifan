Mifan.controller "mDesginCtrl", ($scope, $timeout) ->

  DOC = $scope.DOC

  elMDesignTextarea = DOC["getElementById"] "m-design-input"

  titleMap = 
    "ask": "提出问题"
    "comment": "评论"
    "answer": "回答"

  $scope.mDesignContent = ""

  sendData = {}

  # 设置展示界面类型
  # ask => 提问
  # comment => 评论
  #
  $scope.$on "setMDesignType", (evet, msg) ->
    $scope.viewType = msg
    $scope.title = titleMap[msg]

    switch msg
      when "ask"
        sendData = 
          type: msg
          content: $scope.mDesignContent

    $timeout ->
      elMDesignTextarea.focus()
    , 800

  # 取消内容发送的展示
  # 实际上后台还会继续网络请求发送
  $scope.$on "cancelMDesingSending", ->
    $scope.isSending = no
    $scope.mDesignContent = ""

  $scope.onSubmit = ->
    $scope.isSending = yes
    $scope.$emit "onMDesignSend", sendData


  $scope.$on "onMDesignSendSuccess", (event, msg) ->
    $scope.mDesignContent = ""

    $scope.isSending = no
    $scope.isSendSucs = yes

    $timeout ->
      $scope.isSendSucs = no
      $scope.toggleMDesign() if $scope.isMDesignOpen
    , 800

