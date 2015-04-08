var congoApp = angular.module('congoApp');

congoApp.controller('CarriersNewController', [
  '$scope', '$http', '$location', '$cookieStore', 'flashesFactory',
  function ($scope, $http, $location, $cookieStore, flashesFactory) {
    // Make sure user is totally signed up before continuing.
    $scope.enforceValidAccount();

    $scope.form = {
      name: null,
      trading_partner_id: null,
      supported_transactions: null,
      is_enabled: null,
      npi: null,
      service_types: null,
      tax_id: null,
      first_name: null,
      last_name: null,
      address_1: null,
      address_2: null,
      city: null,
      state: null,
      zip: null,
      phone: null
    };

    $scope.carrierAccountForm = {
      broker_id: null
    }

    $scope.submit = function () {
      $http
        .post('/api/internal/accounts/' + $scope.accountSlug() + '/roles/' + $scope.currentRole() + '/carriers.json', {
          name: $scope.form.name,
          properties: $scope.form,
          carrier_account_properties: $scope.carrierAccountForm
        })
        .success(function (data, status, headers, config) {
          $location.path('/accounts/' + $scope.accountSlug() + '/' + $scope.currentRole() + '/carriers');

          flashesFactory.add('success', 'Successfully created the carrier.');
        })
        .error(function (data, status, headers, config) {
          var error = (data && data.error) ?
            data.error :
            'There was a problem creating the carrier.';

          flashesFactory.add('danger', error);
        });
    };

    $scope.ready();
  }
]);


