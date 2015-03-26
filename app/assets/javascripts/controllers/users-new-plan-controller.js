var congoApp = angular.module('congoApp');

congoApp.controller('UsersNewPlanController', [
  '$scope', '$http', '$location', 'flashesFactory',
  function ($scope, $http, $location, flashesFactory) {
    $scope.pickPlan = function (planName) {
      $http
        .put('/api/internal/users/' + congo.currentUser.id + '/account.json', {
          plan_name: planName
        })
        .success(function (data, status, headers, config) {
          $location.path('/users/new_billing');
        })
        .error(function (data, status, headers, config) {
          var error = (data && data.error) ?
            data.error :
            'There was a problem setting up your plan.';

          flashesFactory.add('danger', error);
        });
    };

    $scope.addInviteCode = function () {
      $http
        .put('/api/internal/users/' + congo.currentUser.id + '/account.json', {
          plan_name: 'premier',
          is_invite: true,
          invite_code: $scope.invitation
        })
        .success(function (data, status, headers, config) {
          $location.path('/users/new_account');
        })
        .error(function (data, status, headers, config) {
          var error = (data && data.error) ?
            data.error :
            'There was a problem setting up your plan.';

          flashesFactory.add('danger', error);
        });
    };

    $scope.ready();
  }
]);

