var congoApp = angular.module('congoApp');

congoApp.controller('UsersNewPlanController', [
  '$scope', '$http', '$location', 'flashesFactory',
  function ($scope, $http, $location, flashesFactory) {
    $scope.pickPlan = function (planName) {
      $http
        .put('/api/v1/users/' + congo.currentUser.id + '.json', {
          plan_name: planName
        })
        .success(function (data, status, headers, config) {
          $location.path('/users/new_billing');
        })
        .error(function (data, status, headers, config) {
          flashesFactory.add('danger', 'There was a problem setting up your plan.');
        });
    };

    $scope.addInviteCode = function () {
      $http
        .put('/api/v1/users/' + congo.currentUser.id + '.json', {
          plan_name: 'premier',
          invite_code: $scope.invitation
        })
        .success(function (data, status, headers, config) {
          $location.path('/users/new_account');
        })
        .error(function (data, status, headers, config) {
          var error = (response.data && response.data.error) ?
            response.data.error :
            'There was a problem setting up your plan.';

          flashesFactory.add('danger', error);
        });
    };

    $scope.ready();
  }
]);

