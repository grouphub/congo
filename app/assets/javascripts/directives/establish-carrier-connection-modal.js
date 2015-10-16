!function() {
  "use strict";

  angular.module('congoApp').directive('establishCarrierConnectionModal', establishCarrierConnectionModal);

  establishCarrierConnectionModal.$inject = ['$http', '$location', 'flashesFactory', 'carrierIdService'];

  function establishCarrierConnectionModal($http, $location, flashesFactory, carrierIdService) {
    var establishCarrierConnectionModalDirective = {
      restrict: 'E',
      replace: true,
      templateUrl: congo.assets['directives/establish-carrier-connection-modal.html'],
      link: modal
    };

    return establishCarrierConnectionModalDirective;

    function modal($scope, $element, $attrs) {
      $scope.carrierIdService = carrierIdService;

      $scope.carrierCredentials = {
        username: null,
        password: null
      };

      $scope.carrierInvoice = {
        file: null
      };

      $scope.uploadCarrierInvoice = function() {
        $('#carrier-invoice').trigger('click');
      };

      $scope.submitCarrierConnection = function() {
        var $form = new FormData();

        $form.append('username',        $scope.carrierCredentials.username);
        $form.append('password',        $scope.carrierCredentials.password);
        $form.append('carrier_id',      $scope.carrierIdService.get());
        $form.append('carrier_invoice', $scope.carrierInvoice.file);
        $form.append('group_slug',      $scope.groupSlug());
        $form.append('applied_by_id',   congo.currentUser.id);

        var request = $http.post(
          '/api/internal/accounts/' + $scope.accountSlug() + '/roles/' + $scope.currentRole() + '/groups/' + $scope.groupSlug() + '/connect_to_carrier',
          $form, { transformRequest: angular.identity, headers: { 'Content-Type' : undefined } }
        );

        request.success(function(response){
          flashesFactory.add('success', 'Successfully connected to carrier.');
          $('#establish-carrier-connection-modal').modal('hide');
          $scope.application         = {};
          $scope.carrierInvoice.file = null;
          $('#carrier-invoice').val(undefined)
        });

        request.error(function(data){
          var error = (data && data.error) ? data.error : 'There was a problem connecting to the carrier.';
          $scope.carrierInvoice.file = null;
          $('#carrier-invoice').val(undefined)
          $('#establish-carrier-connection-modal').modal('hide');
          flashesFactory.add('danger', error);
        });
      };
    }
  };
}();
