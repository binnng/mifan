"use strict"
Mifan.controller "msgCtrl", ($scope, $rootScope) ->

  DOC = $scope.DOC
  
  $scope.$on "$viewContentLoaded", -> $scope.$emit "pageChange", "msg"

  $scope.focus = -> console.log 111



  $scope.setMBill = (index) ->

    $scope.toggleMBill ["love", "answer", "share"]
  

  no
