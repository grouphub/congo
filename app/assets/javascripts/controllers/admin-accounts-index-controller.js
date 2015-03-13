var congoApp = angular.module('congoApp');

congoApp.controller('AdminAccountsIndexController', [
  '$scope', '$http', '$location',
  function ($scope, $http, $location) {
    // Make sure user is admin before continuing.
    $scope.enforceAdmin();

    $scope.accounts = null;

    $http
      .get('/api/internal/admin/accounts.json')
      .success(function (data, status, headers, config) {
        $scope.accounts = data.accounts;

        $scope.ready();
      })
      .error(function (data, status, headers, config) {
        debugger
      });
  }
]);

