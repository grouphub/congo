var congoApp = angular.module('congoApp');

congoApp.controller('AdminCarriersNewController', [
  '$scope', '$http', '$location', 'propertiesFactory',
  function ($scope, $http, $location, propertiesFactory) {
    $scope.elements = [];

    $scope.submit = function () {
      var properties = propertiesFactory.getPropertiesFromElements($scope.elements);

      $http
        .post('/api/internal/admin/carriers.json', {
          name: $scope.name,
          properties: properties
        })
        .success(function (data, status, headers, config) {
          $location.path('/admin/carriers');
        })
        .error(function (data, status, headers, config) {
          debugger
        });
    };

    $http
      .get('/api/internal/accounts/' + $scope.accountSlug() + '/roles/' + $scope.currentRole() + '/properties/carriers.json')
      .success(function (data, status, headers, config) {
        $scope.elements = data.elements;

        $scope.ready();
      })
      .error(function (data, status, headers, config) {
        debugger
      });
  }
]);

