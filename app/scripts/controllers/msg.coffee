"use strict"
Mifan.controller "msgCtrl", ($scope, $rootScope, $http) ->

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
        $scope.askMe = data.result
      else
        $scope.askMeMsg = data.msg

  msg.init()
  

  no
