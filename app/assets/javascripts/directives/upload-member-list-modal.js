var congoApp = angular.module('congoApp');

congoApp.directive('uploadMemberListModal', [
  '$http', '$location', 'flashesFactory',
  function ($http, $location, flashesFactory) {
    return {
      restrict: 'E',
      replace: true,
      templateUrl: congo.assets['directives/upload-member-list-modal.html'],
      link: function ($scope, $element, $attrs) {
        $scope.deleteAccount = function () {
          $http
            .post()
            .then(
              function (response) {
                congo.currentUser = response.data.user;

                flashesFactory.add('success', 'Successfully uploaded member list.');

                //$location.path('/').replace();

                $('#add-new-member-modal').modal('hide');
              },
              function (response) {
                var error = (response.data && response.data.error) ?
                  response.data.error :
                  'An error occurred. Please try uploading the list again later.';

                flashesFactory.add('danger', error);
              }
            );
        };
      }
    };
  }
]);

