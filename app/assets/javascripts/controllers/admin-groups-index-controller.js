var congoApp = angular.module('congoApp');

congoApp.controller('AdminGroupsIndexController', [
  '$scope', '$http', '$location', 'flashesFactory',
  function ($scope, $http, $location, flashesFactory) {
    // Make sure user is admin before continuing.
    $scope.enforceAdmin();

    $scope.groups = null;

    $http
      .get('/api/internal/admin/groups.json')
      .success(function (data, status, headers, config) {
        $scope.groups = data.groups;

        $scope.ready();
      })
      .error(function (data, status, headers, config) {
        var error = (data && data.error) ?
          data.error :
          'There was a problem fetching the list of groups.';

        flashesFactory.add('danger', error);
      });
  }
]);

