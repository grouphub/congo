var congoApp = angular.module('congoApp');

congoApp.controller('AdminBenefitPlansIndexController', [
  '$scope', '$http', '$location', 'flashesFactory',
  function ($scope, $http, $location, flashesFactory) {
    // Make sure user is admin before continuing.
    $scope.enforceAdmin();

    $scope.benefitPlans = null;

    $scope.toggleBenefitPlanAt = function (index) {
      // TODO: Fill this in
    };

    $scope.deleteBenefitPlanAt = function (index) {
      // TODO: Fill this in
    };

    $http
      .get('/api/internal/admin/benefit_plans.json')
      .success(function (data, status, headers, config) {
        $scope.benefitPlans = data.benefit_plans;

        $scope.ready();
      })
      .error(function (data, status, headers, config) {
        var error = (data && data.error) ?
          data.error :
          'There was a problem fetching the benefit plans.';

        flashesFactory.add('danger', error);
      });
  }
]);

