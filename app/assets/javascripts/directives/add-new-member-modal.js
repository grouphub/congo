!function() {
  "use strict";

  angular.module('congoApp').directive('addNewMemberModal', addNewMemberModal);

  addNewMemberModal.$inject = ['$http', '$location', 'flashesFactory'];

  function addNewMemberModal($http, $location, flashesFactory) {
    var addNewMemberModalDirective = {
      restrict: 'E',
      replace: true,
      templateUrl: congo.assets['directives/add-new-member-modal.html'],
      link: modal
    };

    return addNewMemberModalDirective;

    function modal($scope, $element, $attrs) {
<<<<<<< HEAD
=======

>>>>>>> 43b8c25ebc78f40533620f7803972260d964f35c
      $scope.newMember = {
        role_name: 'customer',
        first_name: null,
        last_name: null,
        phone: null,
        email: null
      };

      $scope.submitNewMember = function() {
        $http
          .post('/api/internal/accounts/' + $scope.accountSlug() + '/roles/' + $scope.currentRole() + '/groups/' + $scope.groupSlug() + '/memberships.json', $scope.newMember)
          .then(
            function (response) {
              congo.currentUser = response.data.user;

              flashesFactory.add('success', 'Successfully added the member.');

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
  }
}();
