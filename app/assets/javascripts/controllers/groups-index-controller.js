var congoApp = angular.module('congoApp');

congoApp.controller('GroupsIndexController', [
  '$scope', '$http', '$location', 'flashesFactory',
  function ($scope, $http, $location, flashesFactory) {
    // Make sure user is totally signed up before continuing.
    $scope.enforceValidAccount();

    $scope.toggleGroupAt = function (index) {
      var group = $scope.groups[index];

      if (!group) {
        flashesFactory.add('danger', 'We could not find a matching group.');
      }

      $http
        .put('/api/internal/accounts/' + $scope.accountSlug() + '/roles/' + $scope.currentRole() + '/groups/' + group.slug + '.json', {
          is_enabled: !group.is_enabled    
        })
        .success(function (data, status, headers, config) {
          $scope.groups[index] = data.group;
        })
        .error(function (data, status, headers, config) {
          var error = (data && data.error) ?
            data.error :
            'There was a problem updating your group.';

          flashesFactory.add('danger', error);
        });
    }

    $scope.deleteGroupAt = function (index) {
      var group = $scope.groups[index];

      if (!group) {
        debugger
      }

      $http
        .delete('/api/internal/accounts/' + $scope.accountSlug() + '/roles/' + $scope.currentRole() + '/groups/' + group.slug + '.json')
        .success(function (data, status, headers, config) {
          $scope.groups.splice(index, 1);
        })
        .error(function (data, status, headers, config) {
          var error = (data && data.error) ?
            data.error :
            'There was a problem deleting the group.';

          flashesFactory.add('danger', error);
        });
    };

    $http
      .get('/api/internal/accounts/' + $scope.accountSlug() + '/roles/' + $scope.currentRole() + '/groups.json')
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

