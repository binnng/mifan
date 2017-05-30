
Mifan.controller "homeFeed", ($scope, $http) ->

  feed = 
    init: ->


  feed.init()

  $scope.toggleMBubble = (index) ->
    $scope.newsCollect[index].bblActv = not $scope.newsCollect[index].bblActv

  $scope.setMBill = (index) ->

    $scope.toggleMBill ["love", "comment", "share"]




