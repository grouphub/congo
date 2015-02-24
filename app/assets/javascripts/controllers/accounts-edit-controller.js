var congoApp = angular.module('congoApp');

congoApp.controller('AccountsEditController', [
  '$scope',
  '$location',
  '$http',
  function ($scope, $location, $http) {
    $scope.elements = [];

    $http
      .get('/api/v1/accounts/' + $scope.accountSlug() + '/roles/' + $scope.currentRole() + '/properties/accounts.json')
      .success(function (data, status, headers, config) {
        $scope.elements = data.elements;

        $scope.ready();
      })
      .error(function (data, status, headers, config) {
        debugger
      });
  }
]);

