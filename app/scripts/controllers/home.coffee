"use strict"

Mifan.controller "homeCtrl", ($scope) ->
  $scope.feedType = "news"

  $scope.switchFeedType = (feedType) ->
  	$scope.feedType = feedType

  $scope.$on "$viewContentLoaded", ->
  	$scope.$emit "pageChange", "home"
    # $scope.separateHeight = $(".home-page .main").height()
  	$scope.separateHeight = 0

  $scope.askQuesConent = ""

  $scope.remind = 
  	newsNum: 0
  	answerNum: 2
  	replyNum: '...'
  
  no



