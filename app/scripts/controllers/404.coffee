"use strict"

Mifan.controller "404Ctrl", ($scope) ->

  $scope.$on "$viewContentLoaded", -> $scope.$emit "pageChange", "404"
	  

  no