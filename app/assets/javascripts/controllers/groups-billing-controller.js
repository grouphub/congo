!function() {
  "use strict";

  angular.module('congoApp').controller('GroupsBillingController', GroupsMembersController);

  GroupsBillingController.$inject = ['$scope', '$http', '$location', 'flashesFactory'];

  function GroupsBillingController($scope, $http, $location, flashesFactory){
    // Make sure user is totally signed up before continuing.
    $scope.enforceValidAccount();

    accounts = $scope.accounts;

    $scope.init = function() {
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

      $scope.ready();
    };

    $scope.openAddNewBillingModal = function () {
      $('#add-new-member-modal').modal('show');
    };
  }
}();
