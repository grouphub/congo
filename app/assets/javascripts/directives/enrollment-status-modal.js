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
        $scope.vent.on($scope, 'review-application', function (application) {
          $http
            .get('/api/v1/accounts/' + $scope.accountSlug() + '/roles/' + $scope.currentRole() + '/applications/' + application.id + '/last_activity.json')
            .success(function (response) {
              debugger;
            })
            .error(function (response) {
              debugger;
            });
        });
      }
    };
  }
]);

