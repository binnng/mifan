
Mifan.controller "homeReply", ($scope, $http) ->

  $scope.$emit "clearReplyRemind"

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

      url = "#{API.commentme}#{$scope.privacyParamDir}/page/#{page}"
      url = API.commentme if IsDebug

      $scope.$emit "onPaginationStartChange", page

      cb = (data) ->

        ret = data['ret']
        if String(ret) is "100000"
          newsCollect = data['result']['list']

          for news in newsCollect
            news.feedMod = "replyme" 

            news["commentList"] = [news.comment]

          $scope.newsCollect = newsCollect

          pageData = data['result']['page']

          $scope.$emit "onPaginationGeted", pageData if pageData

          $scope.dataLoaded = yes


      $http.get(url).success cb


  news.init()