!function() {
  "use strict";
  angular.module('congoApp').
    directive('chargesModal', chargesModal);

  payBillModal.$inject = [ '$http', '$location', 'flashesFactory' ];

  function chargesModal() {
    return {
      restrict: 'E',
      replace: true,
      templateUrl: congo.assets['directives/charges-modal.html'],
      controller: 'chargesModalController'
    };
  }
}();