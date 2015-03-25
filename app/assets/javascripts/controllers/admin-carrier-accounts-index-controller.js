var congoApp = angular.module('congoApp');

congoApp.controller('AdminCarrierAccountsIndexController', [
  '$scope', '$http', '$location', 'flashesFactory',
  function ($scope, $http, $location, flashesFactory) {
    // Make sure user is admin before continuing.
    $scope.enforceAdmin();

    $scope.carrierAccounts = null;

    $scope.deleteCarrierAccountAt = function (index) {
      // TODO: Fill this in
    };

    $http
      .get('/api/internal/admin/carrier_accounts.json')
      .success(function (data, status, headers, config) {
        $scope.carrierAccounts = data.carrier_accounts;

        $scope.ready();
      })
      .error(function (data, status, headers, config) {
        var error = (data && data.error) ?
          data.error :
          'There was a problem fetching your carrier accounts.';

        flashesFactory.add('danger', error);
      });
  }
]);

