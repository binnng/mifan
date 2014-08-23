"use strict"
Mifan.controller "msgCtrl", ($scope, $rootScope) ->

  DOC = $scope.DOC
  
  $scope.$on "$viewContentLoaded", -> $scope.$emit "pageChange", "msg"

  $scope.expander = (target) ->
  	#angular.element(target).addClass "active"


  $scope.setMBill = (index) ->

    $scope.toggleMBill ["love", "answer", "share"]
  

  no
