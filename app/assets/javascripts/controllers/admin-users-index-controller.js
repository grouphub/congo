var congoApp = angular.module('congoApp');

congoApp.controller('AdminUsersIndexController', [
  '$scope', '$http', '$location', 'flashesFactory',
  function ($scope, $http, $location, flashesFactory) {
    // Make sure user is admin before continuing.
    $scope.enforceAdmin();

    $scope.users = null;

    $scope.crystalBall = function (user) {
      var data = {
        id: user.id
      };

      $http
        .post('/api/internal/admin/users/' + user.id + '/crystal_ball.json')
        .success(function (data, status, headers, config) {
          congo.currentUser = data.user;

          $location.path('/');

          flashesFactory.add('success', 'You are now signed in on behalf of ' + user.email + '.');
        })
        .error(function (data, status, headers, config) {
          var error = (data && data.error) ?
            data.error :
            'There was a problem fetching the list of users.';

          flashesFactory.add('danger', error);
        });
    };

    $http
      .get('/api/internal/admin/users.json')
      .success(function (data, status, headers, config) {
        $scope.users = data.users;

        $scope.ready();
      })
      .error(function (data, status, headers, config) {
        var error = (data && data.error) ?
          data.error :
          'There was a problem fetching the list of users.';

        flashesFactory.add('danger', error);
      });
  }
]);

