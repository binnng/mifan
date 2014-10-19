
Mifan.controller "homeAnswer", ($scope, $http) ->
  $scope.$emit "clearAnswerRemind"

  $scope.ansMeCollect = []

  news = 
    init: ->
      news.get()

    get: ->
      url = "#{API.answerme}#{$scope.privacyParamDir}"
      url = API.answerme if IsDebug

      cb = (data) ->
        {ret} = data
        if String(ret) is "100000"
          $scope.ansMeCollect = data.result

      $http.get(url,
        cache: "lruCache"
      ).success cb

  news.init()


