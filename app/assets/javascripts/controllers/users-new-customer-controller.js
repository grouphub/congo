var congoApp = angular.module('congoApp');

congoApp.controller('UsersNewCustomerController', [
  '$scope', '$http', '$location',
  function ($scope, $http, $location) {
    var emailToken = $location.search().email_token;

    congo.currentUser = null;

    $scope.signin = function () {

      $scope.$broadcast('show-errors-check-validity');

      if ($scope.memberForm.$invalid) { return; }

      var email = $scope.signin_email;
      var password = $scope.signin_password;

      $http
        .post('/api/v1/users/signin.json', {
          email: email,
          password: password,
          email_token: emailToken
        })
        .success(function (data, status, headers, config) {
          congo.currentUser = data.user;

          $location.path('/');
        })
        .error(function (data, status, headers, config) {
          debugger
        });
    }

    $scope.signup = function () {
      $scope.$broadcast('show-errors-check-validity');

      if ($scope.memberForm.$invalid) { return; }

      $http
        .post('/api/v1/users.json', {
          first_name: $scope.first_name,
          last_name: $scope.last_name,
          email: $scope.email,
          password: $scope.password,
          password_confirmation: $scope.password_confirmation,
          email_token: emailToken
        })
        .success(function (data, status, headers, config) {
          congo.currentUser = data.user;

          $location.path('/');
        })
        .error(function (data, status, headers, config) {
          debugger
        });
    };

    $scope.ready();
  }
]);

