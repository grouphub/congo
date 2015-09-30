!function() {
  "use strict";

  angular.module('congoApp').
    directive('ngFileModel', ngFileModel);

  ngFileModel.$inject = [ '$parse' ];

  function ngFileModel($parse) {
    return {
      restrict: "A",
      link: function($scope, $element, $attrs) {
        var $model = $parse($attrs.ngFileModel);
        $element.bind('change', function(){
          $scope.$apply(function(){ $model.assign($scope, $element[0].files[0]); });
        });

        $scope.$on('file.clear', function() {
          $element.val('');
        });
      }
    };
  };
}();
