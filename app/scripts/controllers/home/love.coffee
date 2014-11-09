
Mifan.controller "homeLove", ($scope, $http) ->
  $scope.$emit "clearLoveRemind"

  API = $scope.API

  # Ajax取到数据进行缓存，用户手动刷新
  $scope.content = ""

  $scope.newsCollect = []

  news = 

    init: ->

      $scope.getPage = news.get
        
      news.get 1


    get: (page) ->

      return no if $scope.isPageLoading

      url = "#{API.lovemefeed}#{$scope.privacyParamDir}/page/#{page}"
      url = API.lovemefeed if IsDebug

      $scope.$emit "onPaginationStartChange", page

      cb = (data) ->

        {ret, result, msg} = data

        if result and result.page
          newsCollect = result['list']

          news.feedMod = "loveme" for news in newsCollect

          $scope.newsCollect = newsCollect

          pageData = result['page']

          $scope.$emit "onPaginationGeted", pageData if pageData

        else
          $scope.errorMsg = msg


        $scope.dataLoaded = yes




      $http.get(url).success cb


  news.init()
