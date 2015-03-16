var congoApp = angular.module('congoApp');

congoApp.controller('CarrierAccountsShowController', [
  '$scope', '$http', '$location',
  function ($scope, $http, $location) {
    // Make sure user is totally signed up before continuing.
    $scope.enforceValidAccount();

    $scope.carriers = [];

    $scope.accountTypes = [
      {
        slug: 'broker',
        name: 'Broker'
      },
      {
        slug: 'tpa',
        name: 'TPA'
      }
    ];

    $scope.form = {
      name: null,
      carrier_slug: null,
      broker_number: null,
      brokerage_name: null,
      tax_id: null,
      account_type: null
    };

    $scope.carrierAccount = null;

    $scope.submit = function () {
      $http
        .put('/api/internal/accounts/' + $scope.accountSlug() + '/roles/' + $scope.currentRole() + '/carrier_accounts/' + $scope.carrierAccountId() + '.json', {
          name: $scope.name,
          properties: $scope.form
        })
        .success(function (data, status, headers, config) {
          $location.path('/accounts/' + $scope.accountSlug() + '/' + $scope.currentRole() + '/carrier_accounts');
        })
        .error(function (data, status, headers, config) {
          debugger
        });
    };

    $http
      .get('/api/internal/accounts/' + $scope.accountSlug() + '/roles/' + $scope.currentRole() + '/carrier_accounts/' + $scope.carrierAccountId() + '.json')
      .success(function (data, status, headers, config) {
        $scope.carrierAccount = data.carrier_account;
        $scope.form = JSON.parse($scope.carrierAccount.properties_data);

        $http
          .get('/api/internal/admin/carriers.json')
          .success(function (data, status, headers, config) {
            $scope.carriers = data.carriers;

            $scope.ready();
          })
          .error(function (data, status, headers, config) {
            debugger
          });
      })
      .error(function (data, status, headers, config) {
        debugger
      });
  }
]);

