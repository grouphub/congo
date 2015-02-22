var congoApp = angular.module('congoApp');

congoApp.controller('AdminCarriersIndexController', [
  '$scope', '$http', '$location',
  function ($scope, $http, $location) {
    // Make sure user is admin before continuing.
    $scope.enforceAdmin();

    $scope.deleteCarrierAt = function (index) {
      var carrier = $scope.carriers[index];

      if (!carrier) {
        debugger
      }

      $http
        .delete('/api/v1/admin/carriers/' + carrier.id + '.json')
        .success(function (data, status, headers, config) {
          $scope.carriers.splice(index, 1);
        })
        .error(function (data, status, headers, config) {
          debugger
        });
    };

    $http
      .get('/api/v1/admin/carriers.json')
      .success(function (data, status, headers, config) {
        $scope.carriers = data.carriers;

        $scope.ready();
      })
      .error(function (data, status, headers, config) {
        debugger
      });
  }
]);

