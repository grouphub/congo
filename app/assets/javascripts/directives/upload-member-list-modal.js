var congoApp = angular.module('congoApp');

congoApp.directive('uploadMemberListModal', [
  '$http', '$location', 'flashesFactory',
  function ($http, $location, flashesFactory) {
    return {
      restrict: 'E',
      replace: true,
      templateUrl: congo.assets['directives/upload-member-list-modal.html'],
      link: function ($scope, $element, $attrs) {
        $scope.uploadMemberList = function() {
          $('#upload_employees_list').click();
        };

        $scope.submitEmployeesListForm = function(){
          $('#send_member_list').submit();
        };

        $scope.sendMemberList = function(){
          var formData = new FormData($('#yourformID')[0]);
          formData.append('employee_list_file', $('#upload_employees_list')[0].files[0]);

          $.ajax({
            url: "/api/internal/accounts/tangosource/roles/broker/groups/my_sixth_group/create_employees_from_list",
            data: formData,
            processData: false,
            contentType: false,
            type: 'POST',
            success: function(data){
              flashesFactory.add('success', 'Successfully uploaded member list.');

              $('#add-new-member-modal').modal('hide');
            }
          });
        };
      }
    };
  }
]);

