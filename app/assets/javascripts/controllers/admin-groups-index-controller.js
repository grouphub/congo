var congoApp = angular.module('congoApp');

congoApp.controller('AdminGroupsIndexController', [
  '$scope', '$http', '$location',
  function ($scope, $http, $location) {
    // Make sure user is admin before continuing.
    $scope.enforceAdmin();

    $scope.groups = null;

    $http
      .get('/api/v1/admin/groups.json')
      .success(function (data, status, headers, config) {
        $scope.groups = data.groups;

        $scope.ready();
      })
      .error(function (data, status, headers, config) {
        debugger
      });
  }
]);

