"use strict"

Mifan.controller "welcomeCtrl", [ "$scope", "$location", ($scope, $location) ->

  $scope.$on "$viewContentLoaded", -> Common.setCurrentPage("welcome")

  $scope.$watch "email + password", ->
  	$scope.isLoginValid = $scope.email and $scope.password

  $scope.loginSubmit = ->
  	
	  

  no

]