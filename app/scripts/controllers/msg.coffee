"use strict"
Mifan.controller "msgCtrl", ($scope, $rootScope, $http, $debug, $timeout) ->

  DOC = $scope.DOC
  
  $scope.$on "$viewContentLoaded", -> $scope.$emit "pageChange", "msg"

  $scope.expander = (target) ->
    #angular.element(target).addClass "active"


  $scope.setMBill = (index) ->

    $scope.toggleMBill ["love", "answer", "share"]

  msg = 
    init: ->
      msg.getAskMe()

      $scope.askMe = []
      $scope.askMeMsg = ""
      $scope.askMeMore = no

    getAskMe: ->
      api = "#{API.askme}#{$scope.privacyParamDir}/type/askme"
      api = API.askme if IsDebug

      $http.get(api).success msg.getAskMeCb

    getAskMeCb: (data) ->
      if String(data.msg) is "ok"
        $scope.askMe = data.result or []
        msg.count = data.result.length

      else
        $scope.askMeMsg = data.msg

    count: 0

  msg.init()

  ans = 
    init: ->
      $scope.send = ans.send

      $scope.$watch $scope.askMe,  ->
        if $scope.askMe.length is 0
          $scope.askMeMsg = "空"

      $scope.$on "ansCb", (event, data) -> ans.sendCb data

    send: (item, msg) ->
      item.isSending = yes

      query = 
        askid: msg.askid
        content: item.content

      $scope.$emit "ans", query

    sendCb: (data) ->
      @content = ""
      @isSending = no

      toastType = ""

      if String(data.ret) is "100000"
        $timeout (=>
          @isSendSucs = yes
          @answerd = yes
          @isSendSucs = no
        ), 1000

        ans.count++

        if ans.count >= msg.count
          $scope.askMe.length = 0

      else 
        toastType = "warn"

      $scope.toast data.msg, toastType

    count: 0


  ans.init()
  

  no
