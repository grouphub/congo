var congoApp = angular.module('congoApp');

congoApp.controller('BenefitPlansIndexController', [
  '$scope', '$http', '$location',
  function ($scope, $http, $location) {
    // Make sure user is totally signed up before continuing.
    $scope.enforceValidAccount();

    $scope.toggleBenefitPlanAt = function (index) {
      var benefitPlan = $scope.benefitPlans[index];

      if (!benefitPlan) {
        debugger
      }

      $http
        .put('/api/v1/accounts/' + $scope.accountSlug() + '/roles/' + $scope.currentRole() + '/benefit_plans/' + benefitPlan.id + '.json', {
          is_enabled: !benefitPlan.is_enabled    
        })
        .success(function (data, status, headers, config) {
          $scope.benefitPlans[index] = data.benefit_plan;
        })
        .error(function (data, status, headers, config) {
          debugger
        });
    }

    $scope.deleteBenefitPlanAt = function (index) {
      var benefitPlan = $scope.benefitPlans[index];

      if (!benefitPlan) {
        debugger
      }

      $http
        .delete('/api/v1/accounts/' + $scope.accountSlug() + '/roles/' + $scope.currentRole() + '/benefit_plans/' + benefitPlan.id + '.json')
        .success(function (data, status, headers, config) {
          $scope.benefitPlans.splice(index, 1);
        })
        .error(function (data, status, headers, config) {
          debugger
        });
    };

    $http
      .get('/api/v1/accounts/' + $scope.accountSlug() + '/roles/' + $scope.currentRole() + '/benefit_plans.json')
      .success(function (data, status, headers, config) {
        $scope.benefitPlans = data.benefit_plans;

        $scope.ready();
      })
      .error(function (data, status, headers, config) {
        debugger
      });
  }
]);

