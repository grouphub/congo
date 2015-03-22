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
        $scope.attempt = null;
        $scope.lastAttempt = null;

        // TODO: Change eligibility modal to use this format
        eventsFactory.on($scope, 'enrollment-status', function (application) {
          $http
            .get('/api/internal/accounts/' + $scope.accountSlug() + '/roles/' + $scope.currentRole() + '/applications/' + application.id + '/last_attempt.json')
            .then(function (response) {
              console.log(response);
              $scope.attempt = response.data.attempt;
              $scope.lastAttempt = _($scope.attempt.data).last();
            })
            .catch(function (response) {
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

