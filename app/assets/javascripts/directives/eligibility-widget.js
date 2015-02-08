var congoApp = angular.module('congoApp');

congoApp.directive('eligibilityWidget', [
  function () {
    return {
      restrict: 'E',
      replace: true,
      templateUrl: congo.assets['directives/eligibility-widget.html'],
      link: function ($scope, $element, $attrs) {
        // ...
      }
    };
  }
]);

