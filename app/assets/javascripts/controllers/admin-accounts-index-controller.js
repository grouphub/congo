var congoApp = angular.module('congoApp');

congoApp.controller('AdminAccountsIndexController', [
  '$scope', '$http', '$location', 'flashesFactory',
  function ($scope, $http, $location, flashesFactory) {
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
        var error = (data && data.error) ?
          data.error :
          'There was a problem fetching accounts.';

        flashesFactory.add('danger', error);
      });
  }
]);

