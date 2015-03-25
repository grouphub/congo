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
        $scope.activities = null;
        $scope.lastActivity = null;

        // TODO: Change eligibility modal to use this format
        eventsFactory.on($scope, 'enrollment-status', function (application) {
          $http
            .get('/api/internal/accounts/' + $scope.accountSlug() + '/roles/' + $scope.currentRole() + '/applications/' + application.id + '/activities.json')
            .then(function (response) {
              console.log(response);
              $scope.activities = response.data.activities;
              $scope.lastActivity = _($scope.activities.data).last();
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

