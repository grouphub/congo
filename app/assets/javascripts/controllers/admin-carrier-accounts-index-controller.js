var congoApp = angular.module('congoApp');

congoApp.controller('AdminCarrierAccountsIndexController', [
  '$scope', '$http', '$location', 'flashesFactory',
  function ($scope, $http, $location, flashesFactory) {
    // Make sure user is admin before continuing.
    $scope.enforceAdmin();

    $scope.carrierAccounts = null;

    $scope.deleteCarrierAccountAt = function (index) {
      var carrierAccount = $scope.carrierAccounts[index];

      if (!carrierAccount) {
        debugger
      }

      $http
        .delete('/api/internal/admin/carrier_accounts/' + carrierAccount.id + '.json')
        .success(function (data, status, headers, config) {
          $scope.carrierAccounts.splice(index, 1);
        })
        .error(function (data, status, headers, config) {
          var error = (data && data.error) ?
            data.error :
            'There was a problem deleting your carrier account.';

          flashesFactory.add('danger', error);
        });
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

