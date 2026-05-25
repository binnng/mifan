"use strict"
Mifan.controller "msgCtrl", ($scope, $rootScope, $http, $debug, $timeout) ->

  DOC = $scope.DOC
  
  $scope.$on "$viewContentLoaded", -> $scope.$emit "pageChange", "msg"

  $scope.setMBill = (index) ->

    $scope.toggleMBill ["love", "answer", "share"]

  message = 
    init: ->
      message.getAskMe()

      $scope.askMe = []
      $scope.askMeMsg = ""
      $scope.askMeMore = no

      $scope.getPage = message.getAskMe

    getAskMe: (page = 1)->
      return no if $scope.isPageLoading

      api = "#{API.askme}#{$scope.privacyParamDir}/type/askme/page/#{page}"
      api = API.askme if IsDebug

      $http.get(api).success message.getAskMeCb

      $scope.$emit "onPaginationStartChange", page

    getAskMeCb: (data) ->

      {ret, msg, result}  = data

      if msg is "ok"
        list = result?['list']
        $scope.askMe = list or []
        message.count = list.length

        $scope.$emit "onPaginationGeted", result['page']

      else
        $scope.errorMsg = msg

      $scope.dataLoaded = yes

    count: 0

  message.init()

  ans = 
    init: ->
      $scope.sendAns = ans.send

      $scope.$watch $scope.askMe,  ->
        if $scope.askMe.length is 0
          $scope.askMeMsg = "空"

      $scope.$on "ansCb", (event, data) -> ans.sendCb data

    # 当前回答的feed
    item: null

    send: (item, data) ->
      item.isSending = yes

      ans.item = item

      query = 
        askid: data.askid
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

          if ans.count >= message.count
            $scope.askMe.length = 0
            
        ), 100

      else 
        toastType = "warn"

      $scope.toast data.msg, toastType

    count: 0


  ans.init()
  

  no
