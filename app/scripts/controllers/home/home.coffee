"use strict"

Mifan.controller "homeCtrl", ["$scope", "$routeParams", ($scope, $routeParams) ->

  legalFeedTypes = [
    "news"
    "answer"
    "reply"
    "love"
  ]

  setCaretLeft = (type) ->
    index = legalFeedTypes.indexOf type
    $scope.caretLeft = "#{index * 25}%"

  $scope.legalFeedTypes = legalFeedTypes

  $scope.caretLeft = "0"

  # 过滤不合法的URL
  if 0 > legalFeedTypes.indexOf $routeParams.type
    $routeParams.type = "news"

  $scope.feedType = $routeParams.type

  $scope.$on "$viewContentLoaded", -> $scope.$emit "pageChange", "home"

  $scope.remind = 
    newsNum: 0
    answerNum: 2
    replyNum: '...'
    loveNum: 0

  # 清除提醒
  $scope.$on "clearAnswerRemind", -> $scope.remind.answerNum = 0
  $scope.$on "clearReplyRemind", -> $scope.remind.replyNum = 0

  # 加载更多
  $scope.loadingMore = ->
    $scope.isLoading = yes

  $scope.switchFeed = (type) ->
    type = type or "news"
    
    $scope.feedType = type
    $scope.isLoading = no

    setCaretLeft(type)
  
  no
]


