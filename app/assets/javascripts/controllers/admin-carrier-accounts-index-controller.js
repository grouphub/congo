var congoApp = angular.module('congoApp');

congoApp.controller('AdminCarrierAccountsIndexController', [
  '$scope', '$http', '$location', '$cookieStore', 'flashesFactory',
  function ($scope, $http, $location, $cookieStore, flashesFactory) {
    // Make sure user is admin before continuing.
    $scope.enforceAdmin();

    // Not the greatest place to put a selector, but c'est la vie.
    $('#admin-index-carrier-accounts-tabs').tab();

    $scope.currentTab = function () {
      return $cookieStore.get('admin-index-carrier-accounts-tab') || 'carrier-accounts';
    };

    $scope.changeTab = function (tabName) {
      $cookieStore.put('admin-index-carrier-accounts-tab', tabName);
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
        .delete('/api/internal/admin/carrier_accounts/' + carrierAccount.id + '.json')
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

    $scope.benefitPlans = null;

    $scope.toggleBenefitPlanAt = function (index) {
      var benefitPlan = $scope.benefitPlans[index];

      if (!benefitPlan) {
        flashesFactory.add('danger', 'We could not find a matching benefit plan.');
      }

      $http
        .put('/api/internal/admin/benefit_plans/' + benefitPlan.id + '.json', {
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
    };

    $scope.deleteBenefitPlanAt = function (index) {
      var benefitPlan = $scope.benefitPlans[index];

      if (!benefitPlan) {
        flashesFactory.add('danger', 'We could not find a matching benefit plan.');
      }

      $http
        .delete('/api/internal/admin/benefit_plans/' + benefitPlan.id + '.json')
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
    }

    $http
      .get('/api/internal/admin/carrier_accounts.json')
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
      .get('/api/internal/admin/benefit_plans.json')
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

