var congoApp = angular.module('congoApp');

congoApp.controller('UsersSigninController', [
  '$scope','$http', '$location', 'flashesFactory',
  function ($scope, $http, $location, flashesFactory) {
    $scope.submit = function () {
       $scope.$broadcast('show-errors-check-validity');

      if ($scope.signinForm.$invalid) { return; }

      $http
        .post('/api/v1/users/signin.json', {
          email: $scope.email,
          password: $scope.password
        })
        .success(function (data, status, headers, config) {
          congo.currentUser = data.user;

          $location.path('/');

          flashesFactory.add('success', 'Welcome back, ' + congo.currentUser.first_name + ' ' + congo.currentUser.last_name + '!');
        })
        .error(function (data, status, headers, config) {
          flashesFactory.add('danger', 'There was a problem signing you in.');
        });
    };

    $scope.ready();
  }
]);

