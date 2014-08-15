// Generated by CoffeeScript 1.7.1
Mifan.directive("accordion", function() {
  return {
    restrict: "EA",
    controller: function($scope) {
      var expanders;
      $scope.expanders = expanders = [];
      this.gotOpened = function(selectedExpander) {
        return angular.forEach(expanders, function(expander) {
          if (selectedExpander !== expander) {
            return expander.active = false;
          }
        });
      };
      return this.addExpander = function(expander) {
        return expanders.push(expander);
      };
    }
  };
});

Mifan.directive("expander", function() {
  return {
    restrict: "EA",
    require: "?accordion",
    transclude: true,
    scope: {},
    link: function(scope, element, attrs, ctrl) {
      console.log(ctrl);
      scope.active = false;
      ctrl.addExpander(scope);
      return scope.toggle = function() {
        scope.active = !scope.active;
        return ctrl.gotOpened(scope);
      };
    }
  };
});
