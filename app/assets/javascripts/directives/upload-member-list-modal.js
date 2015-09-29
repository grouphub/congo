!function() {
  "use strict";

  angular.module('congoApp').directive('uploadMemberListModal', uploadMemberListModal);

  uploadMemberListModal.$inject = ['$http', '$location', 'flashesFactory'];

  function uploadMemberListModal($http, $location, flashesFactory){
    var uploadMemberListModalDirective = {
      restrict: 'E',
      replace: true,
      templateUrl: congo.assets['directives/upload-member-list-modal.html'],
      link: modal
    };

    return uploadMemberListModalDirective;

    function modal($scope, $element, $attrs) {
      $scope.uploadMemberList = function() {
        $('#upload_employees_list').click();
      };

      $scope.submitEmployeesListForm = function(){
        $('#send_member_list').submit();
      };

      $scope.sendMemberList = function(){
        var $form = new FormData();
        $form.append('employee_list_file', $('#upload_employees_list')[0].files[0]);

        var request = $http.post(
          '/api/internal/accounts/' + $scope.accountSlug() + '/roles/' + $scope.currentRole() + '/groups/' + $scope.groupSlug() + '/create_employees_from_list.json',
          $form, { transformRequest: angular.identity, headers: { 'Content-Type' : undefined } }
        )

        request.success(function(response){
          flashesFactory.add('success', 'Successfully uploaded member list.');
          $('#upload-member-list-modal').modal('hide');
          $location.path('/accounts/' + $scope.accountSlug() + '/' + $scope.currentRole() + '/groups/' + $scope.groupSlug());
        });

        request.error(function(){
          flashesFactory.add('danger', 'There was a problem uploading your list');
          $('#upload-member-list-modal').modal('hide');
        });
      };
    }
  };
}();
