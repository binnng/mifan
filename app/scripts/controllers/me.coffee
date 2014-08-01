"use strict"
Mifan.controller "meCtrl", ($scope) ->
  
  $scope.$on "$viewContentLoaded", -> $scope.$emit "pageChange", "me"

  no
