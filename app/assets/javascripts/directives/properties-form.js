var congoApp = angular.module('congoApp');

congoApp.directive('propertiesForm', [
  function () {
    return {
      restrict: 'E',
      replace: true,
      templateUrl: congo.assets['/directives/properties-form.html'],
      link: function ($scope, $element, $attrs) {
        $scope.elements = JSON.parse($attrs.elements);
      }
    };
  }
]);

