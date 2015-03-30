var congoApp = angular.module('congoApp');

congoApp.controller('AdminAccountsIndexController', [
  '$scope', '$http', '$location', 'flashesFactory',
  function ($scope, $http, $location, flashesFactory) {
    // Make sure user is admin before continuing.
    $scope.enforceAdmin();

    $scope.accounts = null;

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
      .get('/api/internal/admin/accounts.json')
      .success(function (data, status, headers, config) {
        $scope.accounts = data.accounts;

        $scope.ready();
      })
      .error(function (data, status, headers, config) {
        var error = (data && data.error) ?
          data.error :
          'There was a problem fetching accounts.';

        flashesFactory.add('danger', error);
      });
  }
]);

