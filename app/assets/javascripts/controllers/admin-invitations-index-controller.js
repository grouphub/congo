var congoApp = angular.module('congoApp');

congoApp.controller('AdminInvitationsIndexController', [
  '$scope', '$http', '$location', 'flashesFactory',
  function ($scope, $http, $location, flashesFactory) {
    // Make sure user is admin before continuing.
    $scope.enforceAdmin();

    $scope.invitations = [];

    $scope.deleteInvitation = function (invitationId) {
      $http
        .delete('/api/internal/admin/invitations/' + invitationId + '.json')
        .success(function (data, status, headers, config) {
          $scope.invitations = _($scope.invitations).reject(function (invitation) {
            return invitation.id === invitationId; 
          });
        })
        .error(function (data, status, headers, config) {
          var error = (data && data.error) ?
            data.error :
            'There was a problem deleting the invitation.';

          flashesFactory.add('danger', error);
        });
    };

    $scope.isLocked = false;

    $scope.newInvitation = function () {
      $scope.isLocked = true;

      $http
        .post('/api/internal/admin/invitations.json', {
          description: $scope.description     
        })
        .success(function (data, status, headers, config) {
          $scope.invitations.push(data.invitation);
          $scope.description = '';

          $scope.isLocked = false;
        })
        .error(function (data, status, headers, config) {
          var error = (data && data.error) ?
            data.error :
            'There was a problem creating a new invitation.';

          flashesFactory.add('danger', error);

          $scope.isLocked = false;
        });
    };

    $http
      .get('/api/internal/admin/invitations.json')
      .success(function (data, status, headers, config) {
        $scope.invitations = data.invitations;

        $scope.ready();
      })
      .error(function (data, status, headers, config) {
        var error = (data && data.error) ?
          data.error :
          'There was a problem fetching the list of invitations.';

        flashesFactory.add('danger', error);
      });
  }
]);

