var congoApp = angular.module('congoApp');

congoApp.controller('AdminCarriersIndexController', [
  '$scope', '$http', '$location', 'flashesFactory',
  function ($scope, $http, $location, flashesFactory) {
    // Make sure user is admin before continuing.
    $scope.enforceAdmin();

    $scope.deleteCarrierAt = function (index) {
      var carrier = $scope.carriers[index];

      if (!carrier) {
        flashesFactory.add('danger', 'We could not find a matching carrier.');
      }

      $http
        .delete('/api/internal/admin/carriers/' + carrier.id + '.json')
        .success(function (data, status, headers, config) {
          $scope.carriers.splice(index, 1);
        })
        .error(function (data, status, headers, config) {
          var error = (data && data.error) ?
            data.error :
            'There was a problem deleting the carrier.';

          flashesFactory.add('danger', error);
        });
    };

    $http
      .get('/api/internal/admin/carriers.json')
      .success(function (data, status, headers, config) {
        $scope.carriers = data.carriers;

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

