var congoApp = angular.module('congoApp');

congoApp.directive('accountDeleteModal', [
  '$http',
  '$location',
  'flashesFactory',
  function ($http, $location, flashesFactory) {
    return {
      restrict: 'E',
      replace: true,
      templateUrl: congo.assets['directives/account-delete-modal.html'],
      link: function ($scope, $element, $attrs) {
        $scope.deleteAccount = function () {
          $http
            .delete('/api/internal/accounts/' + $scope.accountSlug())
            .then(
              function (response) {
                congo.currentUser = response.data.user;

                flashesFactory.add('success', 'Successfully deleted your account.');

                $location.path('/').replace();

                $('#account-delete-modal').modal('hide');
              },
              function (response) {
                var error = (response.data && response.data.error) ?
                  response.data.error :
                  'An error occurred. Please try deleting this account again later.';

                flashesFactory.add('danger', error);
              }
            );
        };
      }
    };
  }
]);

