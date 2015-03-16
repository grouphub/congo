var congoApp = angular.module('congoApp');

congoApp.controller('BenefitPlansNewController', [
  '$scope', '$http', '$location', 'flashesFactory',
  function ($scope, $http, $location, flashesFactory) {
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

    $scope.submit = function () {
      $http
        .post('/api/internal/accounts/' + $scope.accountSlug() + '/roles/' + $scope.currentRole() + '/benefit_plans.json', {
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
      .get('/api/internal/accounts/' + $scope.accountSlug() + '/roles/' + $scope.currentRole() + '/carrier_accounts.json')
      .success(function (data, status, headers, config) {
        $scope.carrierAccounts = data.carrier_accounts;
        $scope.form.carrier_account_id = $scope.carrierAccounts[0].id;

        $scope.ready();
      })
      .error(function (data, status, headers, config) {
        flashesFactory.add('danger', 'There was a problem loading carrier accounts.');
      });
  }
]);

