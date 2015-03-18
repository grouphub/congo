var congoApp = angular.module('congoApp');

congoApp.controller('ApplicationsIndexController', [
  '$scope', '$http', '$location', 'flashesFactory',
  function ($scope, $http, $location, flashesFactory) {
    // Make sure user is totally signed up before continuing.
    $scope.enforceValidAccount();

    $scope.revokeApplication = function (application) {
      if (!application) {
        flashesFactory.add('danger', 'We could not find a matching invitation.');
      }

      $http
        .delete('/api/internal/accounts/' + $scope.accountSlug() + '/roles/' + $scope.currentRole() + '/applications/' + application.id + '.json')
        .success(function (data, status, headers, config) {
          $scope.applications = _($scope.applications).reject(function (a) {
            return application.id === a.id;
          });
        })
        .error(function (data, status, headers, config) {
          var error = (data && data.error) ?
            data.error :
            'There was a problem revoking the application.';

          flashesFactory.add('danger', error);
        });
    };

    $http
      .get('/api/internal/accounts/' + $scope.accountSlug() + '/roles/' + $scope.currentRole() + '/applications.json')
      .success(function (data, status, headers, config) {
        $scope.applications = data.applications;

        $scope.ready();
      })
      .error(function (data, status, headers, config) {
        var error = (data && data.error) ?
          data.error :
          'There was a problem fetching the list of applications.';

        flashesFactory.add('danger', error);
      });
  }
]);

