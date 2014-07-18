"use strict"
Mifan.controller "msgCtrl", ($scope) ->
  
  $scope.$on "$viewContentLoaded", -> Common.setCurrentPage("msg")

  no
