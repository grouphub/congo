var congoApp = angular.module('congoApp');

congoApp.controller('UsersNewCustomerController', [
  '$scope', '$http', '$location', 'flashesFactory',
  function ($scope, $http, $location, flashesFactory) {
    var emailToken = $location.search().email_token;

    congo.currentUser = null;

    $scope.signin = function () {
      $scope.$broadcast('show-errors-check-validity');

      if ($scope.existingAccountForm.$invalid) {
        return;
      }

      var email = $scope.signin_email;
      var password = $scope.signin_password;

      $http
        .post('/api/internal/users/signin.json', {
          email: email,
          password: password,
          email_token: emailToken
        })
        .success(function (data, status, headers, config) {
          congo.currentUser = data.user;

          account = _(congo.currentUser.accounts).last();

          $location.path('/accounts/' + account.slug + '/' + account.role.name);

          flashesFactory.add('success', 'Welcome, ' + congo.currentUser.first_name + ' ' + congo.currentUser.last_name + '!');
        })
        .error(function (data, status, headers, config) {
          var error = (data && data.error) ?
            data.error :
            'There was a problem signing your in.';

          flashesFactory.add('danger', error);
        });
    }

    $scope.signup = function () {
      $scope.$broadcast('show-errors-check-validity');

      if ($scope.memberForm.$invalid) {
        return;
      }

      $http
        .post('/api/internal/users.json', {
          first_name: $scope.first_name,
          last_name: $scope.last_name,
          email: $scope.email,
          password: $scope.password,
          password_confirmation: $scope.password_confirmation,
          email_token: emailToken
        })
        .success(function (data, status, headers, config) {
          congo.currentUser = data.user;

          account = _(congo.currentUser.accounts).last();

          $location.path('/accounts/' + account.slug + '/' + account.role.name);

          flashesFactory.add('success', 'Welcome, ' + congo.currentUser.first_name + ' ' + congo.currentUser.last_name + '!');
        })
        .error(function (data, status, headers, config) {
          var error = (data && data.error) ?
            data.error :
            'There was a problem signing you up.';

          flashesFactory.add('danger', error);
        });
    };

    $scope.ready();
  }
]);

