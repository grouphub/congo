var congoApp = angular.module('congoApp');

congoApp.controller('CarrierAccountsNewController', [
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

    $scope.submit = function () {
      $http
        .post('/api/internal/accounts/' + $scope.accountSlug() + '/roles/' + $scope.currentRole() + '/carrier_accounts.json', {
          name: $scope.name,
          properties: $scope.form
        })
        .success(function (data, status, headers, config) {
          $location.path('/accounts/' + $scope.accountSlug() + '/' + $scope.currentRole() + '/carrier_accounts');
        })
        .error(function (data, status, headers, config) {
          flashesFactory.add('danger', 'There was a problem saving your carrier account.');
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
        flashesFactory.add('danger', 'There was a problem loading carriers.');
      });
  }
]);

