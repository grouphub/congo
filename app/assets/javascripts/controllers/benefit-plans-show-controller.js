var congoApp = angular.module('congoApp');

congoApp.controller('BenefitPlansShowController', [
  '$scope', '$http', '$location',
  function ($scope, $http, $location) {
    // Make sure user is totally signed up before continuing.
    $scope.enforceValidAccount();

    $scope.benefitPlan = null;

    $http
      .get('/api/v1/accounts/' + $scope.accountSlug() + '/roles/' + $scope.currentRole() + '/benefit_plans/' + $scope.benefitPlanId() + '.json', {
        name: $scope.name
      })
      .success(function (data, status, headers, config) {
        $scope.benefitPlan = data.benefit_plan;

        $scope.ready();
      })
      .error(function (data, status, headers, config) {
        debugger
      });
  }
]);

