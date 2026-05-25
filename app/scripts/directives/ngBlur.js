 Mifan.directive('ngBlur', function() {
   return {
     restrict: 'A',
     link: function(scope, element, attrs) {
       angular.element(element).bind('blur', function() {
         scope.$apply(attrs.ngBlur);
       });
     }
   };
 });