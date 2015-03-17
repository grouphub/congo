var congoApp = angular.module('congoApp');

congoApp.controller('AdminCarriersNewController', [
  '$scope', '$http', '$location', 'flashesFactory', 'propertiesFactory',
  function ($scope, $http, $location, flashesFactory, propertiesFactory) {
    $scope.form = {
      name: null,
      npi: null,
      trading_partner_id: null,
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

    $scope.submit = function () {
      $http
        .post('/api/internal/admin/carriers.json', {
          name: $scope.form.name,
          properties: $scope.form
        })
        .success(function (data, status, headers, config) {
          $location.path('/admin/carriers');
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

