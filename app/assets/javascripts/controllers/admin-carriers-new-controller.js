var congoApp = angular.module('congoApp');

congoApp.controller('AdminCarriersNewController', [
  '$scope', '$http', '$location', 'flashesFactory', 'propertiesFactory',
  function ($scope, $http, $location, flashesFactory, propertiesFactory) {
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
          var error = (data && data.error) ?
            data.error :
            'There was a problem creating the carrier.';

          flashesFactory.add('danger', error);
        });
    };

    $http
      .get('/api/internal/accounts/' + $scope.accountSlug() + '/roles/' + $scope.currentRole() + '/properties/carriers.json')
      .success(function (data, status, headers, config) {
        $scope.elements = data.elements;

        $scope.ready();
      })
      .error(function (data, status, headers, config) {
        var error = (data && data.error) ?
          data.error :
          'There was a problem fetching carrier properties.';

        flashesFactory.add('danger', error);
      });
  }
]);

