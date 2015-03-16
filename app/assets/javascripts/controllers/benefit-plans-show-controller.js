var congoApp = angular.module('congoApp');

congoApp.controller('BenefitPlansShowController', [
  '$scope', '$http', '$location', '$timeout',
  function ($scope, $http, $location, $timeout) {
    // Make sure user is totally signed up before continuing.
    $scope.enforceValidAccount();

    $scope.carrierAccounts = null;
    $scope.form = {
      name: null,
      carrier_account_id: null,
      plan_type: null,
      exchange_plan: null,
      small_group: null
    };

    $scope.benefitPlan = null;

    $scope.submit = function () {
      $http
        .put('/api/internal/accounts/' + $scope.accountSlug() + '/roles/' + $scope.currentRole() + '/benefit_plans/' + $scope.benefitPlanId() + '.json', {
          name: $scope.form.name,
          carrier_account_id: $scope.form.carrier_account_id,
          properties: $scope.form
        })
        .success(function (data, status, headers, config) {
          $location.path('/accounts/' + $scope.accountSlug() + '/' + $scope.currentRole() + '/benefit_plans');
        })
        .error(function (data, status, headers, config) {
          flashesFactory.add('danger', 'There was a problem saving your benefit plan.');
        });
    };

    $http
      .get('/api/internal/accounts/' + $scope.accountSlug() + '/roles/' + $scope.currentRole() + '/benefit_plans/' + $scope.benefitPlanId() + '.json')
      .success(function (data, status, headers, config) {
        $scope.benefitPlan = data.benefit_plan;
        $scope.form = JSON.parse($scope.benefitPlan.properties_data);
        $scope.form.carrier_account_id = $scope.benefitPlan.carrier_account_id;

        $http
          .get('/api/internal/accounts/' + $scope.accountSlug() + '/roles/' + $scope.currentRole() + '/carrier_accounts.json')
          .success(function (data, status, headers, config) {
            $scope.carrierAccounts = data.carrier_accounts;

            // TODO: This is not the right way to do this, but I can't get the select to behave.
            $timeout(function () {
              $('.benefit-plans-show form #carrier_account').val($scope.benefitPlan.carrier_account_id);
            });

            $scope.ready();
          })
          .error(function (data, status, headers, config) {
            flashesFactory.add('danger', 'There was a problem loading carrier accounts.');
          });
      })
      .error(function (data, status, headers, config) {
        flashesFactory.add('danger', 'There was a problem loading the benefit plan.');
      });
  }
]);

