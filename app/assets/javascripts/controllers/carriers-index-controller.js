var congoApp = angular.module('congoApp');

congoApp.controller('CarriersIndexController', [
  '$scope', '$http', '$location', '$cookieStore', 'flashesFactory',
  function ($scope, $http, $location, $cookieStore, flashesFactory) {
    // Not the greatest place to put a selector, but c'est la vie.
    $('#index-carriers-tabs').tab();

    $scope.currentTab = function () {
      return $cookieStore.get('index-carriers-tab') || 'carriers';
    };

    $scope.changeTab = function (tabName) {
      $cookieStore.put('index-carriers-tab', tabName);
    };

    // --------
    // Carriers
    // --------

    $scope.carriers = null;

    $scope.carrierCanBeActivated = function (carrier) {
      return !carrier.carrier_account;
    };

    $scope.carrierCanBeDeactivated = function (carrier) {
      return !carrier.account_id && carrier.carrier_account;
    };

    $scope.carrierCanBeDeleted = function (carrier) {
      return carrier.account_id;
    };

    $scope.activateCarrierAt = function (index) {
      console.log('yes');
    };

    $scope.deactivateCarrierAt = function (index) {
      console.log('si');
    };

    $scope.deleteCarrierAt = function (index) {
      console.log('aye');
    };

    // -------------
    // Benefit Plans
    // -------------

    $scope.benefitPlans = null;

    $scope.benefitPlanCanBeActivated = function (benefitPlan) {
      return !benefitPlan.account_benefit_plan;
    };

    $scope.benefitPlanCanBeDeactivated = function (benefitPlan) {
      return !benefitPlan.account_id && benefitPlan.account_benefit_plan;
    };

    $scope.benefitPlanCanBeDeleted = function (benefitPlan) {
      return benefitPlan.account_id;
    };

    $scope.activateBenefitPlanAt = function (index) {
      console.log('yes');
    };

    $scope.deactivateBenefitPlanAt = function (index) {
      console.log('si');
    };

    $scope.deleteBenefitPlanAt = function (index) {
      console.log('aye');
    };

    // -------
    // Loading
    // -------

    function done () {
      if ($scope.carriers && $scope.benefitPlans) {
        $scope.ready();
      }
    }

    $http
      .get('/api/internal/accounts/' + $scope.accountSlug() + '/roles/' + $scope.currentRole() + '/carriers.json')
      .success(function (data, status, headers, config) {
        $scope.carriers = data.carriers;

        done();
      })
      .error(function (data, status, headers, config) {
        var error = (data && data.error) ?
          data.error :
          'There was a problem fetching carriers.';

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
          'There was a problem fetching benefit plans.';

        flashesFactory.add('danger', error);
      });
  }
]);

