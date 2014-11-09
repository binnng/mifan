"use strict"
Mifan.controller "quesDetailCtrl", ($scope, $timeout, $http, $routeParams, $location) ->

  $scope.$on "$viewContentLoaded", -> $scope.$emit "pageChange", "ques"

  askid = $routeParams.id

  ques = 
    init: ->
      ques.getInfo askid
      ques.getAns 1

      $scope.$on "onGetAskInfoCb", (e, data) ->
        ques.getInfoCb data

      $scope.$on "onGetAskAnswersCb", (e, data) ->
        ques.getAnsCb data

      $scope.getPage = ques.getAns

    getInfo: (askid) -> 
      $scope.$emit "onGetAskInfo", askid

    getInfoCb: (data) ->
      {ret, result} = data

      if String(ret) is "100000"
        $scope.askInfo = result

      $scope.dataInfoLoaded = yes

    getAns: (page = 1) ->
      $scope.$emit "onGetAskAnswers", askid: askid, page: page
      $scope.$emit "onPaginationStartChange", page


    getAnsCb: (data) ->
      {ret, result} = data
      if String(ret) is "100000"
        askAns = result["list"]

        ans.ask = askid: askid for ans in askAns

        $scope.askAns = askAns

        $scope.$emit "onPaginationGeted", result["page"]

      $scope.dataLoaded = yes




  ques.init()










