var congoApp = angular.module('congoApp');

congoApp.controller('GroupsNewController', [
  '$scope', '$http', '$location', 'propertiesFactory',
  function ($scope, $http, $location, propertiesFactory) {
    // Make sure user is totally signed up before continuing.
    $scope.enforceValidAccount();

    $scope.elements = [];

    $scope.submit = function () {
      var properties = propertiesFactory.getPropertiesFromElements($scope.elements);

      $http
        .post('/api/internal/accounts/' + $scope.accountSlug() + '/roles/' + $scope.currentRole() + '/groups.json', {
          name: $scope.name,
          properties: properties
        })
        .success(function (data, status, headers, config) {
          $location.path('/accounts/' + $scope.accountSlug() + '/' + $scope.currentRole() + '/groups');

          $scope.ready();
        })
        .error(function (data, status, headers, config) {
          debugger
        });
    };

    $http
      .get('/api/internal/accounts/' + $scope.accountSlug() + '/roles/' + $scope.currentRole() + '/properties/groups.json')
      .success(function (data, status, headers, config) {
        $scope.elements = data.elements;

        $scope.ready();
      })
      .error(function (data, status, headers, config) {
        debugger
      });
  }
]);

