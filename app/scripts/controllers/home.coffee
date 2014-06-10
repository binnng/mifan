"use strict"
angular.module("mifan").controller "homeCtrl", ($scope) ->
  $scope.awesomeThings = [
    "HTML5 Boilerplate"
    "AngularJS"
    "Karma"
  ]

  $scope.$on "$viewContentLoaded", -> Common.setCurrentPage("home")
  
  no
