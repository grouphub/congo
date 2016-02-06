!function() {
  "use strict";

  angular.module('congoApp').
    controller('ChargesModalController', ChargesModalController);

  ChargesModalController.$inject = [ '$scope', '$http', 'flashesFactory' ];

  function ChargesModalController($scope, $http, flashesFactory) {
    $scope.$on('modal.charges', function(scope, membership, benefitPlans) {
      $scope.membership = membership;
      $scope.benefitPlans = benefitPlans;
    });
  };
}();