"use strict"
angular.module("mifan").controller "msgCtrl", ($scope) ->
  
  $scope.$on "$viewContentLoaded", -> Common.setCurrentPage("msg")

  no
