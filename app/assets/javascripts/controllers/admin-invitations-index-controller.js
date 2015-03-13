var congoApp = angular.module('congoApp');

congoApp.controller('AdminInvitationsIndexController', [
  '$scope', '$http', '$location',
  function ($scope, $http, $location) {
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
          debugger
        });
    };

    $scope.newInvitation = function () {
      $http
        .post('/api/internal/admin/invitations.json', {
          description: $scope.description     
        })
        .success(function (data, status, headers, config) {
          $scope.invitations.push(data.invitation);
          $scope.description = '';
        })
        .error(function (data, status, headers, config) {
          debugger
        });
    };

    $http
      .get('/api/internal/admin/invitations.json')
      .success(function (data, status, headers, config) {
        $scope.invitations = data.invitations;

        $scope.ready();
      })
      .error(function (data, status, headers, config) {
        debugger
      });
  }
]);

