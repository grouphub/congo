var congoApp = angular.module('congoApp');

congoApp.controller('CarrierAccountsShowController', [
  '$scope', '$http', '$location',
  function ($scope, $http, $location) {
    // Make sure user is totally signed up before continuing.
    $scope.enforceValidAccount();

    $scope.carrierAccount = null;

    $http
      .get('/api/internal/accounts/' + $scope.accountSlug() + '/roles/' + $scope.currentRole() + '/carrier_accounts/' + $scope.carrierAccountId() + '.json')
      .success(function (data, status, headers, config) {
        $scope.carrierAccount = data.carrier_account;

        $scope.ready();
      })
      .error(function (data, status, headers, config) {
        debugger
      });
  }
]);

