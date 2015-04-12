var congoApp = angular.module('congoApp');

congoApp.controller('AdminCarriersNewController', [
  '$scope', '$http', '$location', 'flashesFactory',
  function ($scope, $http, $location, flashesFactory) {
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

    $scope.isLocked = false;

    $scope.submit = function () {
      $scope.isLocked = true;

      $http
        .post('/api/internal/admin/carriers.json', {
          name: $scope.form.name,
          properties: $scope.form
        })
        .success(function (data, status, headers, config) {
          $location.path('/admin/carriers');

          flashesFactory.add('success', 'Successfully created the carrier.');

          $scope.isLocked = false;
        })
        .error(function (data, status, headers, config) {
          var error = (data && data.error) ?
            data.error :
            'There was a problem creating the carrier.';

          flashesFactory.add('danger', error);

          $scope.isLocked = false;
        });
    };

    $scope.ready();
  }
]);

