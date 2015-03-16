var congoApp = angular.module('congoApp');

congoApp.controller('AdminCarriersShowController', [
  '$scope', '$http', '$location', 'flashesFactory',
  function ($scope, $http, $location, flashesFactory) {
    // Make sure user is admin before continuing.
    $scope.enforceAdmin();

    $http
      .get('/api/internal/admin/carriers/' + $scope.carrierSlug() + '.json')
      .success(function (data, status, headers, config) {
        $scope.carrier = data.carrier;

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

