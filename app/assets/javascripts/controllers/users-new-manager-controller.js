var congoApp = angular.module('congoApp');

congoApp.controller('UsersNewManagerController', [
  '$scope', '$http', '$location', 'flashesFactory',
  
  function ($scope, $http, $location, flashesFactory) {
    $scope.save = function() {
      $scope.$broadcast('show-errors-check-validity');

      if ($scope.userForm.$invalid) {
        return;
      }

      // TODO: Add code to add the user...?
    };

    $scope.submit = function () {
      $scope.$broadcast('show-errors-check-validity');

      if ($scope.userForm.$invalid) {
        return;
      }

      $http
        .post('/api/internal/users.json', {
          first_name: $scope.first_name,
          last_name: $scope.last_name,
          email: $scope.email,
          password: $scope.password,
          password_confirmation: $scope.password_confirmation,
          type: 'broker'
        })
        .success(function (data, status, headers, config) {
          congo.currentUser = data.user;

          $location.path('/users/new_plan');
        })
        .error(function (data, status, headers, config) {
          var error = (data && data.error) ?
            data.error :
            'There was a problem creating your account.';

          flashesFactory.add('danger', error);
        });
    };

    $scope.ready();
  }
]);

