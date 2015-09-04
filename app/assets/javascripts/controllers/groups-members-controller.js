var congoApp = angular.module('congoApp');

congoApp.controller('GroupsMembersController', [
  '$scope', '$http', '$location', 'flashesFactory',
  function ($scope, $http, $location, flashesFactory) {
    // Make sure user is totally signed up before continuing.
    $scope.enforceValidAccount();

    $http
      .get('/api/internal/accounts/' + $scope.accountSlug() + '/roles/' + $scope.currentRole() + '/groups/' + $scope.groupSlug() + '.json')
      .success(function (data, status, headers, config) {
        $scope.group = data.group;
      })
      .error(function (data, status, headers, config) {
        var error = (data && data.error) ?
          data.error :
          'There was a problem fetching the group data.';

        flashesFactory.add('danger', error);
      });

      $scope.openAddNewMemberModal = function () {
        $('#add-new-member-modal').modal('show');
      };

    $scope.ready();
  }
]);
