var congoApp = angular.module('congoApp');

congoApp.directive('enrollmentStatusModal', [
  '$http',
  'eventsFactory',
  'flashesFactory',
  function ($http, eventsFactory, flashesFactory) {
    return {
      restrict: 'E',
      replace: true,
      templateUrl: congo.assets['directives/enrollment-status-modal.html'],
      link: function ($scope, $element, $attrs) {
        $scope.date = new Date();

        // TODO: Change eligibility modal to use this format
        eventsFactory.on($scope, 'enrollment-status', function (application) {
          $http
            .get('/api/internal/accounts/' + $scope.accountSlug() + '/roles/' + $scope.currentRole() + '/applications/' + application.id + '/last_attempt.json')
            .success(function (response) {
              // TODO: Fill this in...
            })
            .error(function (response) {
              var error = (response.data && response.data.error) ?
                response.data.error :
                'There was a problem saving your group.';

              flashesFactory.add('danger', error);
            });
        });
      }
    };
  }
]);

