var congoApp = angular.module('congoApp');

congoApp.controller('UsersNewPlanController', [
  '$scope', '$http', '$location', 'flashesFactory',
  function ($scope, $http, $location, flashesFactory) {
    $scope.planIsLocked = false;

    $scope.pickPlan = function (planName) {
      $scope.planIsLocked = true;

      $http
        .put('/api/internal/users/' + congo.currentUser.id + '/account.json', {
          plan_name: planName
        })
        .success(function (data, status, headers, config) {
          $location.path('/users/new_billing');

          $scope.planIsLocked = false;
        })
        .error(function (data, status, headers, config) {
          var error = (data && data.error) ?
            data.error :
            'There was a problem setting up your plan.';

          flashesFactory.add('danger', error);

          $scope.planIsLocked = false;
        });
    };

    $scope.inviteIsLocked = false;

    $scope.addInviteCode = function () {
      $scope.inviteIsLocked = true;

      $http
        .put('/api/internal/users/' + congo.currentUser.id + '/invitation.json', {
          plan_name: 'premier',
          is_invite: true,
          invite_code: $scope.invitation
        })
        .success(function (data, status, headers, config) {
          $location.path('/users/new_account');

          $scope.inviteIsLocked = false;
        })
        .error(function (data, status, headers, config) {
          var error = (data && data.error) ?
            data.error :
            'There was a problem setting up your plan.';

          flashesFactory.add('danger', error);

          $scope.inviteIsLocked = false;
        });
    };

    $scope.ready();
  }
]);

