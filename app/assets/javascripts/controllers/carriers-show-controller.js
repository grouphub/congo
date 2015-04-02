var congoApp = angular.module('congoApp');

congoApp.controller('CarriersShowController', [
  '$scope', '$http', '$location', 'flashesFactory',
  function ($scope, $http, $location, flashesFactory) {
    $scope.carrier = null;
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

    $scope.carrierAccountForm = {

    };

    $scope.submit = function () {
      $http
        .put('/api/internal/accounts/' + $scope.accountSlug() + '/roles/' + $scope.currentRole() + '/carriers/' + $scope.carrierSlug() + '.json', {
          name: $scope.form.name,
          properties: $scope.form,
          carrier_account_properties: $scope.carrierAccountForm
        })
        .success(function (data, status, headers, config) {
          $location.path('/accounts/' + $scope.accountSlug() + '/' + $scope.currentRole() + '/carriers');

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
      .get('/api/internal/accounts/' + $scope.accountSlug() + '/roles/' + $scope.currentRole() + '/carriers/' + $scope.carrierSlug() + '.json')
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

