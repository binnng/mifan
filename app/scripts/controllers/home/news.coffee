
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

      return no if $scope.isPageLoading

      url = "#{API.news}#{$scope.privacyParamDir}/page/#{page}"
      url = API.news if IsDebug

      $scope.$emit "onPaginationStartChange", page

      cb = (data) ->

        {ret, result, msg} = data
        
        if result and result.page
          $scope.newsCollect = result['list']

          $scope.$emit "onPaginationGeted", result['page']
        else 
          $scope.errorMsg = msg

        $scope.dataLoaded = yes


      $http.get(url).success cb


  news.init()
      


