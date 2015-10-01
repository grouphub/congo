!function() {
  "use strict";

  angular.module('congoApp').
    controller('UploadApplicationModalController', UploadApplicationModalController);

  UploadApplicationModalController.$inject = [ '$scope', '$http', 'flashesFactory' ];

  function UploadApplicationModalController($scope, $http, flashesFactory) {
    $scope.$on('modal.upload-application', function(scope, membership, benefitPlans) {
      $scope.membership = membership;
      $scope.benefitPlans = benefitPlans;
    });

    $scope.submitApplicationPDF = function() {
      var $form      = new FormData()
        , membership = $scope.membership;

      $form.append('pdf_attachment',  $scope.application.pdf_attachment);
      $form.append('benefit_plan_id', $scope.application.benefit_plan_id)
      $form.append('group_slug',      $scope.groupSlug());
      $form.append('applied_by_id',   congo.currentUser.id);
      $form.append('user_id',         membership.user_id);

      var request = $http.post(
        '/api/internal/accounts/' + membership.slug + '/memberships/' + membership.id + '/applications',
        $form, { transformRequest: angular.identity, headers: { 'Content-Type' : undefined } }
      );

      request.success(function(response){
        $scope.membership.applications.push(response.application);
        flashesFactory.add('success', 'Successfully uploaded application PDF');
        $('#upload-application-modal').modal('hide');
        $scope.application = {};
      });

      request.error(function(){
        var error = (data && data.error) ?  data.error : 'There was a problem creating your application.';
        flashesFactory.add('danger', error);
      });
    };
  };
}();
