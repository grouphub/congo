var congoApp = angular.module('congoApp');

congoApp.controller('UsersResetPasswordController', [
  '$scope','$http', '$location', '$routeParams', 'flashesFactory',
  function ($scope, $http, $location, $routeParams, flashesFactory) {
    $scope.user = {

    };

    $scope.passwordConfirmChanged = function () {
      var isMatch = ($scope.user.password === $scope.user.password_confirmation);
      $scope.resetPasswordForm.password_confirmation.$setValidity('password_match', isMatch)
    };

    $scope.submit = function (isValid) {
      $scope.$broadcast('show-errors-check-validity');

      if (!isValid) {
        return;
      }

      var id = $routeParams.id;
      var passwordToken = $routeParams.password_token;

      $http
        .post('/api/internal/users/' + id + '/reset_password/' + passwordToken + '.json', {
          password: $scope.user.password,
          password_confirmation: $scope.user.password_confirmation,
        })
        .success(function (data, status, headers, config) {
          $location.path('/users/signin');

          flashesFactory.add('success', 'Your password has been reset. Please sign in again.');
        })
        .error(function (data, status, headers, config) {
          var error = (data && data.error) ?
            data.error :
            'There was a problem resetting your password.';

          flashesFactory.add('danger', error);
        });
    };

    $scope.ready();
  }
]);

