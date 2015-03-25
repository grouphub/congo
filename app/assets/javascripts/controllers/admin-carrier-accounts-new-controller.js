var congoApp = angular.module('congoApp');

congoApp.controller('AdminCarrierAccountsNewController', [
  '$scope', '$http', '$location', 'flashesFactory',
  function ($scope, $http, $location, flashesFactory) {
    // Make sure user is admin before continuing.
    $scope.enforceAdmin();

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
        .post('/api/internal/admin/carrier_accounts.json', {
          name: $scope.name,
          properties: $scope.form
        })
        .success(function (data, status, headers, config) {
          $location.path('/admin/carrier_accounts');
        })
        .error(function (data, status, headers, config) {
          var error = (data && data.error) ?
            data.error :
            'There was a problem creating the carrier account.';

          flashesFactory.add('danger', error);
        });
    };

    $http
      .get('/api/internal/admin/carriers.json')
      .success(function (data, status, headers, config) {
        $scope.carriers = data.carriers;
        $scope.form.carrier_slug = data.carriers[0].slug;
        $scope.form.account_type = $scope.accountTypes[0].slug;

        $scope.ready();
      })
      .error(function (data, status, headers, config) {
        var error = (data && data.error) ?
          data.error :
          'There was a problem fetching the list of carriers.';

        flashesFactory.add('danger', error);
      });
  }
]);

