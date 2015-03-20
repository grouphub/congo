var congoApp = angular.module('congoApp');

congoApp.controller('UsersShowController', [
  '$scope', '$http', '$location', 'flashesFactory',
  function ($scope, $http, $location, flashesFactory) {
    $scope.user = null;

    $scope.$watch('user');

    $http
      .get('/api/internal/users/' + $scope.userId() + '.json')
      .success(function (data, status, headers, config) {
        $scope.user = data.user;

        $scope.ready();
      })
      .error(function (data, status, headers, config) {
        var error = (data && data.error) ?
          data.error :
          'There was a problem fetching your user data.';

        flashesFactory.add('danger', error);
      });
  }
]);

