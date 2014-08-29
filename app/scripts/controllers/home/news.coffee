
Mifan.controller "homeNews", ($scope, $timeout, $http) ->

  API = $scope.API

  # ajax取到数据进行缓存，用户手动刷新
  $scope.content = "最新动态"

  $scope.toggleMBubble = (index) ->
    $scope.newsCollect[index].bblActv = not $scope.newsCollect[index].bblActv

  $scope.setMBill = (index) ->

    $scope.toggleMBill ["love", "comment", "share"]

  $scope.newsCollect = []

  getNews = ->

    url = "#{API.news}#{$scope.privacyParamDir}"

    url = API.news if IsDebug

    cb = (data) ->
      ret = data['ret']

      if String(ret) is "100000"
        $scope.newsCollect = data['result']

    $http.get(url, {}).success cb

  getNews()