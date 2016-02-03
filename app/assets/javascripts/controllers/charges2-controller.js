!function() {
  "use strict";

  angular.module('congoApp').
    controller('Charges2ModalController', ChargesModalController);

  ChargesModalController.$inject = [ '$scope', '$http', 'flashesFactory' ];

  function Charges2ModalController($scope, $http, flashesFactory) {
    $scope.$on('modal.charges', function(scope, membership, benefitPlans) {
      $scope.membership = membership;
      $scope.benefitPlans = benefitPlans;
    });
  };
}();