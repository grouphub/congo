var congoApp = angular.module('congoApp');

congoApp.controller('UsersSigninController', [
  '$scope','$http', '$location', 'flashesFactory',
  function ($scope, $http, $location, flashesFactory) {
    $scope.submit = function () {
      $scope.$broadcast('show-errors-check-validity');

      if ($scope.signinForm.$invalid) {
        return;
      }

      $http
        .post('/api/internal/users/signin.json', {
          email: $scope.email,
          password: $scope.password
        })
        .success(function (data, status, headers, config) {
          var accounts;
          var account;

          congo.currentUser = data.user;

          accounts = $scope.accounts();

          // Redirect the user to their first account.
          if (accounts) {
            account = accounts[0];

            if (account) {
              if (account.slug === 'admin') {
                $location
                  .path('/admin')
                  .replace();
              } else {
                if (
                  account.role.name === 'customer' &&
                  account.enabled_group_count === 1 &&
                  account.first_enabled_group
                ) {
                  $location
                    .path('/accounts/' + account.slug + '/' + account.role.name + '/groups/' + account.first_enabled_group.slug)
                    .replace();
                } else {
                  $location
                    .path('/accounts/' + account.slug + '/' + account.role.name)
                    .replace();
                }
              }

              return;
            }
          }

          flashesFactory.add('success', 'Welcome back, ' + congo.currentUser.first_name + ' ' + congo.currentUser.last_name + '!');
        })
        .error(function (data, status, headers, config) {
          var error = (data && data.error) ?
            data.error :
            'There was a problem signing you in.';

          flashesFactory.add('danger', error);
        });
    };

    $scope.ready();
  }
]);

