var congoApp = angular.module('congoApp');

congoApp.controller('CarrierAccountsIndexController', [
  '$scope', '$http', '$location', '$cookieStore', 'flashesFactory',
  function ($scope, $http, $location, $cookieStore, flashesFactory) {
    // Make sure user is totally signed up before continuing.
    $scope.enforceValidAccount();

    // Not the greatest place to put a selector, but c'est la vie.
    $('#index-carrier-accounts-tabs').tab();

    $scope.currentTab = function () {
      return $cookieStore.get('index-carrier-accounts-tab') || 'carrier-accounts';
    };

    $scope.changeTab = function (tabName) {
      $cookieStore.put('index-carrier-accounts-tab', tabName);
    };

    // ----------------
    // Carrier Accounts
    // ----------------

    $scope.carrierAccounts = null;

    $scope.deleteCarrierAccountAt = function (index) {
      var carrierAccount = $scope.carrierAccounts[index];

      if (!carrierAccount) {
        debugger
      }

      $http
        .delete('/api/internal/accounts/' + $scope.accountSlug() + '/roles/' + $scope.currentRole() + '/carrier_accounts/' + carrierAccount.id + '.json')
        .success(function (data, status, headers, config) {
          $scope.carrierAccounts.splice(index, 1);
        })
        .error(function (data, status, headers, config) {
          var error = (data && data.error) ?
            data.error :
            'There was a problem deleting your carrier account.';

          flashesFactory.add('danger', error);
        });
    };

    // -------------
    // Benefit Plans
    // -------------

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

    function done () {
      if ($scope.benefitPlans && $scope.carrierAccounts) {
        $scope.ready();
      }
    };

    $http
      .get('/api/internal/accounts/' + $scope.accountSlug() + '/roles/' + $scope.currentRole() + '/carrier_accounts.json')
      .success(function (data, status, headers, config) {
        $scope.carrierAccounts = data.carrier_accounts;

        done();
      })
      .error(function (data, status, headers, config) {
        var error = (data && data.error) ?
          data.error :
          'There was a problem fetching your carrier accounts.';

        flashesFactory.add('danger', error);
      });

    $http
      .get('/api/internal/accounts/' + $scope.accountSlug() + '/roles/' + $scope.currentRole() + '/benefit_plans.json')
      .success(function (data, status, headers, config) {
        $scope.benefitPlans = data.benefit_plans;

        done();
      })
      .error(function (data, status, headers, config) {
        var error = (data && data.error) ?
          data.error :
          'There was a problem fetching the benefit plans.';

        flashesFactory.add('danger', error);
      });
  }
]);

