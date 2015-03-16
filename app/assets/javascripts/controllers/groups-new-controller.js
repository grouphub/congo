var congoApp = angular.module('congoApp');

congoApp.controller('GroupsNewController', [
  '$scope', '$http', '$location', 'flashesFactory',
  function ($scope, $http, $location, flashesFactory) {
    // Make sure user is totally signed up before continuing.
    $scope.enforceValidAccount();

    $scope.form = {
      name: null,
      group_id: null
    };

    $scope.submit = function () {
      $http
        .post('/api/internal/accounts/' + $scope.accountSlug() + '/roles/' + $scope.currentRole() + '/groups.json', {
          name: $scope.form.name,
          properties: $scope.form
        })
        .success(function (data, status, headers, config) {
          $location.path('/accounts/' + $scope.accountSlug() + '/' + $scope.currentRole() + '/groups');

          // TODO: Does this need to be here?
          $scope.ready();
        })
        .error(function (data, status, headers, config) {
          flashesFactory.add('danger', 'There was a problem creating the group.');
        });
    };

    $scope.ready();
  }
]);

