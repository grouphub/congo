var congoApp = angular.module('congoApp');

congoApp.controller('UsersShowController', [
  '$scope', '$http', '$location',
  function ($scope, $http, $location) {
    $scope.user = null;

    $scope.$watch('user');

    $http
      .get('/api/internal/users/' + $scope.userId() + '.json')
      .success(function (data, status, headers, config) {
        $scope.user = data.user;

        $scope.ready();
      })
      .error(function (data, status, headers, config) {
        debugger
      });
  }
]);

