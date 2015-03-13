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
                  .replace();;
              } else {
                $location
                  .path('/accounts/' + account.slug + '/' + account.role.name)
                  .replace();;
              }

              return;
            }
          }

          flashesFactory.add('success', 'Welcome back, ' + congo.currentUser.first_name + ' ' + congo.currentUser.last_name + '!');
        })
        .error(function (data, status, headers, config) {
          flashesFactory.add('danger', 'There was a problem signing you in.');
        });
    };

    $scope.ready();
  }
]);

