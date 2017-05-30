// Generated by CoffeeScript 1.7.1
Mifan.controller("homeAnswer", function($scope, $http) {
  var news;
  $scope.$emit("clearAnswerRemind");
  $scope.ansMeCollect = [];
  news = {
    init: function() {
      news.get();
      return $scope.getPage = news.get;
    },
    get: function(page) {
      var cb, url;
      if (page == null) {
        page = 1;
      }
      url = "" + API.answerme + $scope.privacyParamDir + "/page/" + page;
      if (IsDebug) {
        url = API.answerme;
      }
      $scope.$emit("onPaginationStartChange", page);
      cb = function(data) {
        var result, ret;
        ret = data.ret, result = data.result;
        if (result) {
          $scope.ansMeCollect = result['list'];
          $scope.$emit("onPaginationGeted", result['page']);
        } else {
          $scope.errorMsg = data.msg;
        }
        return $scope.dataLoaded = true;
      };
      return $http.get(url).success(cb);
    }
  };
  return news.init();
});