Mifan.controller "friendCtrl", ($scope) ->

  $scope.$on "$viewContentLoaded", -> $scope.$emit "pageChange", "friend"

  $scope.feedType = "follow"

  $scope.switchFeed = (type) -> $scope.feedType = type or "follow"