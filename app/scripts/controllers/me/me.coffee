"use strict"
Mifan.controller "meCtrl", ($scope) ->
  
  $scope.$on "$viewContentLoaded", -> $scope.$emit "pageChange", "me"

 	legalFeedTypes = [
    "ask"
    "answer"
    "love"
  ]

  $scope.feedType = "ask"

  # 加载更多
  $scope.loadingMore = ->
    $scope.isLoading = yes

  $scope.switchFeed = (type) ->
    type = type or "ask"
    
    $scope.feedType = type
    $scope.isLoading = no