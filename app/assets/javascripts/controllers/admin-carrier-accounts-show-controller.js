var congoApp = angular.module('congoApp');

congoApp.controller('AdminCarrierAccountsShowController', [
  '$scope', '$http', '$location', 'flashesFactory',
  function ($scope, $http, $location, flashesFactory) {
    // Make sure user is admin before continuing.
    $scope.enforceAdmin();

    $scope.carrierAccount = null;
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

    $scope.submit = function () {
      $http
        .put('/api/internal/admin/carrier_accounts/' + $scope.carrierAccountId() + '.json', {
          name: $scope.name,
          properties: $scope.form
        })
        .success(function (data, status, headers, config) {
          $location.path('/admin/carrier_accounts');
        })
        .error(function (data, status, headers, config) {
          var error = (data && data.error) ?
            data.error :
            'There was a problem saving your carrier account.';

          flashesFactory.add('danger', error);
        });
    };

    $http
      .get('/api/internal/admin/carrier_accounts/' + $scope.carrierAccountId() + '.json')
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
            var error = (data && data.error) ?
              data.error :
              'There was a problem fetching the carriers.';

            flashesFactory.add('danger', error);
          });
      })
      .error(function (data, status, headers, config) {
        var error = (data && data.error) ?
          data.error :
          'There was a problem fetching the carrier account.';

        flashesFactory.add('danger', error);
      });
  }
]);

