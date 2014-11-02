"use strict"
Mifan.controller "msgCtrl", ($scope, $rootScope, $http, $debug, $timeout) ->

  DOC = $scope.DOC
  
  $scope.$on "$viewContentLoaded", -> $scope.$emit "pageChange", "msg"

  $scope.setMBill = (index) ->

    $scope.toggleMBill ["love", "answer", "share"]

  msg = 
    init: ->
      msg.getAskMe()

      $scope.askMe = []
      $scope.askMeMsg = ""
      $scope.askMeMore = no

      $scope.getPage = msg.getAskMe

    getAskMe: (page = 1)->
      return no if $scope.isPageLoading

      api = "#{API.askme}#{$scope.privacyParamDir}/type/askme/page/#{page}"
      api = API.askme if IsDebug

      $http.get(api).success msg.getAskMeCb

      $scope.$emit "onPaginationStartChange", page

    getAskMeCb: (data) ->
      if String(data.msg) is "ok"
        list = data.result?['list']
        $scope.askMe = list or []
        msg.count = list.length

        $scope.$emit "onPaginationGeted", data['result']['page']

      else
        $scope.askMeMsg = data.msg

      $scope.dataLoaded = yes

    count: 0

  msg.init()

  ans = 
    init: ->
      $scope.send = ans.send

      $scope.$watch $scope.askMe,  ->
        if $scope.askMe.length is 0
          $scope.askMeMsg = "空"

      $scope.$on "ansCb", (event, data) -> ans.sendCb data

    # 当前回答的feed
    item: null

    send: (item, msg) ->
      item.isSending = yes

      ans.item = item

      query = 
        askid: msg.askid
        content: item.content

      $scope.$emit "ans", query

    sendCb: (data) ->
      item = ans.item

      item.content = ""
      item.isSending = no

      toastType = ""

      if String(data.ret) is "100000"
        $timeout (=>
          item.isSendSucs = yes
          item.answerd = yes
          item.isSendSucs = no

          ans.count++

          if ans.count >= msg.count
            $scope.askMe.length = 0
            
        ), 100

      else 
        toastType = "warn"

      $scope.toast data.msg, toastType

    count: 0


  ans.init()
  

  no
