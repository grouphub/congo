var congoApp = angular.module('congoApp');

congoApp.directive('eligibilityModal', [
  function () {
    return {
      restrict: 'E',
      replace: true,
      templateUrl: congo.assets['directives/eligibility-modal.html'],
      link: function ($scope, $element, $attrs) {
        // ...
      }
    };
  }
]);

