var congoApp = angular.module('congoApp');

congoApp.directive('enrollmentStatusModal', [
  '$http',
  'eventsFactory',
  function ($http, eventsFactory) {
    return {
      restrict: 'E',
      replace: true,
      templateUrl: congo.assets['directives/enrollment-status-modal.html'],
      link: function ($scope, $element, $attrs) {
        $scope.date = new Date();

        // TODO: Change eligibility modal to use this format
        eventsFactory.on($scope, 'enrollment-status', function (application) {
          // ...
        });
      }
    };
  }
]);

