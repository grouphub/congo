var congoApp = angular.module('congoApp');

congoApp.controller('UsersShowController', [
  '$scope', '$http', '$location', 'flashesFactory',
  function ($scope, $http, $location, flashesFactory) {
    $scope.user = null;
    $scope.passwordData = null;

    $scope.$watch('user');

    $scope.isLocked = false;

    $scope.submit = function () {
      $scope.isLocked = true;

      var data = {
        first_name: $scope.user.first_name,
        last_name: $scope.user.last_name,
        email: $scope.user.email
      };

      $http
        .put('/api/internal/users/' + $scope.userId() + '.json', data)
        .success(function (data, status, headers, config) {
          $scope.user = data.user;

          flashesFactory.add('success', 'User has been updated.');

          $scope.isLocked = false;
        })
        .error(function (data, status, headers, config) {
          var error = (data && data.error) ?
            data.error :
            'There was a problem fetching your user data.';

          flashesFactory.add('danger', error);

          $scope.isLocked = false;
        });
    };

    $scope.passwordIsLocked = false;

    $scope.submitPassword = function () {
      $scope.passwordIsLocked = true;

      $http
        .put('/api/internal/users/' + $scope.userId() + '.json', $scope.passwordData)
        .success(function (data, status, headers, config) {
          $scope.user = data.user;

          flashesFactory.add('success', 'Password has been updated.');

          $scope.passwordIsLocked = false;
        })
        .error(function (data, status, headers, config) {
          var error = (data && data.error) ?
            data.error :
            'There was a problem fetching your user data.';

          flashesFactory.add('danger', error);

          $scope.passwordIsLocked = false;
        });
    };

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

