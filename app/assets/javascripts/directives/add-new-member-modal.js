var congoApp = angular.module('congoApp');

congoApp.directive('addNewMemberModal', [
  '$http',
  '$location',
  'flashesFactory',
  function ($http, $location, flashesFactory) {
    return {
      restrict: 'E',
      replace: true,
      templateUrl: congo.assets['directives/add-new-member-modal.html'],
      link: function ($scope, $element, $attrs) {
        $scope.newMember = {
          first_name: null,
          last_name: null,
          phone: null,
          email: null
        };

        $scope.submitNewMember = function() {
          $http
            .post()
            .then(
              function (response) {
                congo.currentUser = response.data.user;

                flashesFactory.add('success', 'Successfully added the member.');

                //$location.path('/').replace();

                $('#add-new-member-modal').modal('hide');
              },
              function (response) {
                var error = (response.data && response.data.error) ?
                  response.data.error :
                  'An error occurred. Please try adding a user again later.';

                flashesFactory.add('danger', error);
              }
            );
        };
      }
    };
  }
]);

