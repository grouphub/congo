var congoApp = angular.module('congoApp');

congoApp.controller('CarriersIndexController', [
  '$scope', '$http', '$location', '$cookieStore', 'flashesFactory',
  function ($scope, $http, $location, $cookieStore, flashesFactory) {
    // Make sure user is totally signed up before continuing.
    $scope.enforceValidAccount();

    // Not the greatest place to put a selector, but c'est la vie.
    $('#index-carriers-tabs').tab();

    $scope.currentTab = function () {
      return $cookieStore.get('index-carriers-tab') || 'carriers';
    };

    $scope.changeTab = function (tabName) {
      $cookieStore.put('index-carriers-tab', tabName);
    };

    $scope.search = {
      carriers: '',
      benefitPlans: ''
    }

    // --------
    // Carriers
    // --------

    $scope.carriers = null;

    $scope.carriersToShow = function () {
      if ($scope.search.carriers.length > 0) {
        return _($scope.carriers)
          .select(function (carrier) {
            return carrier.name.toLowerCase()
              .indexOf($scope.search.carriers.toLowerCase()) > -1;
          });
      } else {
        return $scope.carriers;
      }
    };

    $scope.carrierCanBeActivated = function (carrier) {
      return !carrier.carrier_account;
    };

    $scope.carrierCanBeDeleted = function (carrier) {
      return carrier.carrier_account;
    };

    $scope.deleteCarrierAt = function (index) {
      var carrier = $scope.carriers[index];

      $http
        .delete('/api/internal/accounts/' + $scope.accountSlug() + '/roles/' + $scope.currentRole() + '/carriers/' + carrier.slug + '.json')
        .success(function (data, status, headers, config) {
          // Only delete the carrier if it was created by the account.
          if (carrier.account_id) {
            $scope.carriers.splice(index, 1);
          } else {
            carrier.carrier_account = null;
          }
        })
        .error(function (data, status, headers, config) {
          var error = (data && data.error) ?
            data.error :
            'There was a problem deleting the carrier.';

          flashesFactory.add('danger', error);
        });
    };

    // -------------
    // Benefit Plans
    // -------------

    $scope.benefitPlans = null;

    $scope.benefitPlansToShow = function () {
      if ($scope.search.benefitPlans.length > 0) {
        return _($scope.benefitPlans)
          .select(function (benefitPlan) {
            return benefitPlan.name.toLowerCase()
              .indexOf($scope.search.benefitPlans.toLowerCase()) > -1;
          });
      } else {
        return $scope.benefitPlans;
      }
    };

    $scope.benefitPlanCanBeActivated = function (benefitPlan) {
      return !benefitPlan.account_benefit_plan;
    };

    $scope.benefitPlanCanBeDeleted = function (benefitPlan) {
      return benefitPlan.account_benefit_plan;
    };

    $scope.benefitPlanCanBeEnabled = function (benefitPlan) {
      return benefitPlan.account_benefit_plan;
    };

    $scope.toggleBenefitPlanAt = function (index) {
      var benefitPlan = $scope.benefitPlans[index];

      if (!benefitPlan) {
        flashesFactory.add('danger', 'We could not find a matching benefit plan.');
      }

      $http
        .put('/api/internal/accounts/' + $scope.accountSlug() + '/roles/' + $scope.currentRole() + '/benefit_plans/' + benefitPlan.slug + '.json', {
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

      $http
        .delete('/api/internal/accounts/' + $scope.accountSlug() + '/roles/' + $scope.currentRole() + '/benefit_plans/' + benefitPlan.slug + '.json')
        .success(function (data, status, headers, config) {
          // Only delete the benefit plan if it was created by the account.
          if (benefitPlan.account_id) {
            $scope.benefitPlans.splice(index, 1);
          } else {
            benefitPlan.account_benefit_plan = null;
          }
        })
        .error(function (data, status, headers, config) {
          var error = (data && data.error) ?
            data.error :
            'There was a problem deleting the carrier.';

          flashesFactory.add('danger', error);
        });
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

