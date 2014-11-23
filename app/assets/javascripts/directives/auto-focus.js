var congoApp = angular.module('congoApp');

congoApp.directive('autoFocus', [
  '$timeout',
  function ($timeout) {
    return {
      restrict: 'AC',
      link: function ($scope, $element) {
        $scope.$watch('ready', function (show) {
          $timeout(function () {
            $element[0].focus();
          }, 100);
        });
      }
    };
  }
]);

