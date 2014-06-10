"use strict"
angular.module("mifan").controller "meCtrl", ($scope) ->
  
  $scope.$on "$viewContentLoaded", -> Common.setCurrentPage("me")

  no
