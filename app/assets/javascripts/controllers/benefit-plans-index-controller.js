var congoApp = angular.module('congoApp');

congoApp.controller('BenefitPlansIndexController', [
  '$scope', '$http', '$location', 'flashesFactory',
  function ($scope, $http, $location, flashesFactory) {
    // Make sure user is totally signed up before continuing.
    $scope.enforceValidAccount();

    $scope.toggleBenefitPlanAt = function (index) {
      var benefitPlan = $scope.benefitPlans[index];

      if (!benefitPlan) {
        flashesFactory.add('danger', 'We could not find a matching benefit plan.');
      }

      $http
        .put('/api/internal/accounts/' + $scope.accountSlug() + '/roles/' + $scope.currentRole() + '/benefit_plans/' + benefitPlan.id + '.json', {
          is_enabled: !benefitPlan.is_enabled    
        })
        .success(function (data, status, headers, config) {
          $scope.benefitPlans[index] = data.benefit_plan;
        })
        .error(function (data, status, headers, config) {
          var error = (data && data.error) ?
            data.error :
            'There was a problem updating the benefit plan.';

          flashesFactory.add('danger', error);
        });
    }

    $scope.deleteBenefitPlanAt = function (index) {
      var benefitPlan = $scope.benefitPlans[index];

      if (!benefitPlan) {
        flashesFactory.add('danger', 'We could not find a matching benefit plan.');
      }

      $http
        .delete('/api/internal/accounts/' + $scope.accountSlug() + '/roles/' + $scope.currentRole() + '/benefit_plans/' + benefitPlan.id + '.json')
        .success(function (data, status, headers, config) {
          $scope.benefitPlans.splice(index, 1);
        })
        .error(function (data, status, headers, config) {
          var error = (data && data.error) ?
            data.error :
            'There was a problem deleting the benefit plan.';

          flashesFactory.add('danger', error);
        });
    };

    $http
      .get('/api/internal/accounts/' + $scope.accountSlug() + '/roles/' + $scope.currentRole() + '/benefit_plans.json')
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

