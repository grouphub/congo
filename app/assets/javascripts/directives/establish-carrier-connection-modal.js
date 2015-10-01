!function() {
  "use strict";

  angular.module('congoApp').directive('establishCarrierConnectionModal', establishCarrierConnectionModal);

  establishCarrierConnectionModal.$inject = ['$http', '$location', 'flashesFactory'];

  function establishCarrierConnectionModal($http, $location, flashesFactory) {
    var establishCarrierConnectionModalDirective = {
      restrict: 'E',
      replace: true,
      templateUrl: congo.assets['directives/establish-carrier-connection-modal.html'],
      link: modal
    };

    return establishCarrierConnectionModalDirective;

    function modal($scope, $element, $attrs) {
      $scope.carrierCredentials = {
        username: null,
        password: null
      };

      $scope.submitCarrierConnection = function() {
        //API calls pending to be implemented
      };
    }
  }
}();
