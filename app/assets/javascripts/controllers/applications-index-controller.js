var congoApp = angular.module('congoApp');

congoApp.controller('ApplicationsIndexController', [
  '$scope', '$http', '$location',
  function ($scope, $http, $location) {
    // Make sure user is totally signed up before continuing.
    $scope.enforceValidAccount();

    $scope.revokeApplication = function (application) {
      if (!application) {
        debugger
      }

      $http
        .delete('/api/internal/accounts/' + $scope.accountSlug() + '/roles/' + $scope.currentRole() + '/applications/' + application.id + '.json')
        .success(function (data, status, headers, config) {
          $scope.applications = _($scope.applications).reject(function (a) {
            return application.id === a.id;
          });
        })
        .error(function (data, status, headers, config) {
          debugger
        });
    };

    $http
      .get('/api/internal/accounts/' + $scope.accountSlug() + '/roles/' + $scope.currentRole() + '/applications.json')
      .success(function (data, status, headers, config) {
        $scope.applications = data.applications;

        $scope.ready();
      })
      .error(function (data, status, headers, config) {
        debugger
      });
  }
]);

