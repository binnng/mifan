
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

        {ret, result} = data

        if result and result.page
          newsCollect = result['list']

          for news in newsCollect
            news.feedMod = "replyme" 

            news["commentList"] = [news.comment]

          $scope.newsCollect = newsCollect

          pageData = result['page']

          $scope.$emit "onPaginationGeted", pageData if pageData

        else 
          $scope.errorMsg = data.msg

        $scope.dataLoaded = yes


      $http.get(url).success cb


  news.init()