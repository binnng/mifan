
Mifan.controller "homeAnswer", ($scope, $http) ->
  $scope.$emit "clearAnswerRemind"

  $scope.ansMeCollect = []

  news = 
    init: ->
      news.get()

      $scope.getPage = news.get


    get: (page = 1) ->

      url = "#{API.answerme}#{$scope.privacyParamDir}/page/#{page}"
      url = API.answerme if IsDebug

      $scope.$emit "onPaginationStartChange", page

      cb = (data) ->
        {ret, result} = data

        if result
          $scope.ansMeCollect = result['list']

          $scope.$emit "onPaginationGeted", result['page']

        else 
          $scope.errorMsg = data.msg


        $scope.dataLoaded = yes


      $http.get(url).success cb

  news.init()


