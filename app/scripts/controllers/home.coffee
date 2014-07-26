"use strict"

Mifan.controller "homeCtrl", ["$scope", "$routeParams", ($scope, $routeParams) ->

  $scope.legalFeedTypes = [
    "news"
    "answer"
    "reply"
  ]

  # 过滤不合法的URL
  if 0 > $scope.legalFeedTypes.indexOf $routeParams.type
    $routeParams.type = "news"

  $scope.feedType = $routeParams.type

  $scope.$on "$viewContentLoaded", -> $scope.$emit "pageChange", "home"

  $scope.remind = 
  	newsNum: 0
  	answerNum: 2
  	replyNum: '...'

  # 清除提醒
  $scope.$on "clearAnswerRemind", -> $scope.remind.answerNum = 0
  $scope.$on "clearReplyRemind", -> $scope.remind.replyNum = 0

  # 加载更多
  $scope.loadingMore = ->
    $scope.isLoading = yes
  
  no
]


