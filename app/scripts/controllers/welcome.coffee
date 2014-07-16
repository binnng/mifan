"use strict"

Mifan.controller "welcomeCtrl", [ "$scope", "$location", ($scope, $location) ->

  $scope.$on "$viewContentLoaded", -> Common.setCurrentPage("welcome")

  $location.$$rewrite "/home"

  console.log $location
	  

  no

]