var congoApp = angular.module('congoApp');

congoApp.controller('UsersForgotPasswordController', [
  '$scope','$http', '$location', 'flashesFactory',
  function ($scope, $http, $location, flashesFactory) {
    $scope.user = {

    };

    $scope.submit = function (isValid) {
      $scope.$broadcast('show-errors-check-validity');

      if (!isValid) {
        return;
      }

      $http
        .post('/api/internal/users/forgot_password.json', {
          email: $scope.user.email,
        })
        .success(function (data, status, headers, config) {
          var email = $scope.user.email;

          $scope.user.email = '';

          flashesFactory.add('success', 'An email has been sent to ' + email + '. Check your email for instructions.');
        })
        .error(function (data, status, headers, config) {
          var error = (data && data.error) ?
            data.error :
            'There was a problem retrieving your user information.';

          flashesFactory.add('danger', error);
        });
    };

    $scope.ready();
  }
]);

