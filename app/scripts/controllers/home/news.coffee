
Mifan.controller "homeNews", ($scope, $timeout, $http, $time) ->

  API = $scope.API

  # ajax取到数据进行缓存，用户手动刷新
  $scope.content = ""

  $scope.newsCollect = []

  news = 
    init: ->

      # 接受验证登录成功
      $scope.$on "getHomeNews", -> news.get()
      if $scope.isLogin
        news.get()

    get: ->
      url = "#{API.news}#{$scope.privacyParamDir}"
      url = API.news if IsDebug

      cb = (data) ->
        ret = data['ret']
        if String(ret) is "100000"
          $scope.newsCollect = data['result']

      $http.get(url,
        cache: "lruCache"
      ).success cb

  news.init()
      


