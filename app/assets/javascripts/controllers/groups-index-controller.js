var congoApp = angular.module('congoApp');

congoApp.controller('GroupsIndexController', [
  '$scope', '$http', '$location',
  function ($scope, $http, $location) {
    // Make sure user is totally signed up before continuing.
    $scope.enforceValidAccount();

    $scope.toggleGroupAt = function (index) {
      var group = $scope.groups[index];

      if (!group) {
        debugger
      }

      $http
        .put('/api/internal/accounts/' + $scope.accountSlug() + '/roles/' + $scope.currentRole() + '/groups/' + group.id + '.json', {
          is_enabled: !group.is_enabled    
        })
        .success(function (data, status, headers, config) {
          $scope.groups[index] = data.group;
        })
        .error(function (data, status, headers, config) {
          debugger
        });
    }

    $scope.deleteGroupAt = function (index) {
      var group = $scope.groups[index];

      if (!group) {
        debugger
      }

      $http
        .delete('/api/internal/accounts/' + $scope.accountSlug() + '/roles/' + $scope.currentRole() + '/groups/' + group.id + '.json')
        .success(function (data, status, headers, config) {
          $scope.groups.splice(index, 1);
        })
        .error(function (data, status, headers, config) {
          debugger
        });
    };

    $http
      .get('/api/internal/accounts/' + $scope.accountSlug() + '/roles/' + $scope.currentRole() + '/groups.json')
      .success(function (data, status, headers, config) {
        $scope.groups = data.groups;

        $scope.ready();
      })
      .error(function (data, status, headers, config) {
        debugger
      });
  }
]);

