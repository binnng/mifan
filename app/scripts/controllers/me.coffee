"use strict"
Mifan.controller "meCtrl", ($scope) ->
  
  $scope.$on "$viewContentLoaded", -> Common.setCurrentPage("me")

  no
