
Mifan.controller "homeNews", ($scope, $timeout, $http, $time) ->

  API = $scope.API

  # ajax取到数据进行缓存，用户手动刷新
  $scope.content = ""

  $scope.newsCollect = []

  news = 

    init: ->

      getFirstPage = ->
        news.get 1

      # 接受验证登录成功
      $scope.$on "getHomeNews", getFirstPage
      getFirstPage() if $scope.isLogin 

      $scope.getPage = news.get
        


    get: (page) ->
      url = "#{API.news}#{$scope.privacyParamDir}/page/#{page}"
      url = API.news if IsDebug

      $scope.$emit "onPaginationStartChange", page

      cb = (data) ->

        ret = data['ret']
        if String(ret) is "100000"
          $scope.newsCollect = data['result']['list']

          $scope.$emit "setPaginationData", data['result']['page']

          $scope.$emit "onScrollTop"

      $http.get(url).success cb


  news.init()
      


