"use strict"
Mifan.controller "msgCtrl", ($scope) ->
  
  $scope.$on "$viewContentLoaded", -> $scope.$emit "pageChange", "msg"

  no
