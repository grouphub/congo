var congoApp = angular.module('congoApp');

congoApp.controller('AdminCarriersShowController', [
  '$scope', '$http', '$location', 'flashesFactory',
  function ($scope, $http, $location, flashesFactory) {
    // Make sure user is admin before continuing.
    $scope.enforceAdmin();

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
        .put('/api/internal/admin/carriers/' + $scope.carrierSlug() + '.json', {
          name: $scope.form.name,
          properties: $scope.form
        })
        .success(function (data, status, headers, config) {
          $location.path('/admin/carriers');

          flashesFactory.add('success', 'Successfully updated the carrier.');
        })
        .error(function (data, status, headers, config) {
          var error = (data && data.error) ?
            data.error :
            'There was a problem creating the carrier.';

          flashesFactory.add('danger', error);
        });
    };

    $http
      .get('/api/internal/admin/carriers/' + $scope.carrierSlug() + '.json')
      .success(function (data, status, headers, config) {
        $scope.carrier = data.carrier;
        $scope.form = JSON.parse($scope.carrier.properties_data);

        $scope.ready();
      })
      .error(function (data, status, headers, config) {
        var error = (data && data.error) ?
          data.error :
          'There was a problem fetching the carrier.';

        flashesFactory.add('danger', error);
      });
  }
]);

