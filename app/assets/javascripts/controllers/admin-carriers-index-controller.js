var congoApp = angular.module('congoApp');

congoApp.controller('AdminCarriersIndexController', [
  '$scope', '$http', '$location', '$cookieStore', 'flashesFactory',
  function ($scope, $http, $location, $cookieStore, flashesFactory) {
    // Make sure user is admin before continuing.
    $scope.enforceAdmin();

    // Not the greatest place to put a selector, but c'est la vie.
    $('#admin-index-carriers-tabs').tab();

    $scope.currentTab = function () {
      return $cookieStore.get('admin-index-carriers-tab') || 'carriers';
    };

    $scope.changeTab = function (tabName) {
      $cookieStore.put('admin-index-carriers-tab', tabName);
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

    $scope.deleteCarrierAt = function (index) {
      var carrier = $scope.carriers[index];

      if (!carrier) {
        flashesFactory.add('danger', 'We could not find a matching carrier.');
      }

      $http
        .delete('/api/internal/admin/carriers/' + carrier.id + '.json')
        .success(function (data, status, headers, config) {
          $scope.carriers.splice(index, 1);
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

    $scope.toggleBenefitPlanAt = function (index) {
      var benefitPlan = $scope.benefitPlans[index];

      if (!benefitPlan) {
        flashesFactory.add('danger', 'We could not find a matching benefit plan.');
      }

      $http
        .put('/api/internal/admin/benefit_plans/' + benefitPlan.slug + '.json', {
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
        .delete('/api/internal/admin/benefit_plans/' + benefitPlan.slug + '.json')
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

    // -------
    // Loading
    // -------

    function done () {
      if ($scope.carriers && $scope.benefitPlans) {
        $scope.ready();
      }
    }

    $http
      .get('/api/internal/admin/carriers.json')
      .success(function (data, status, headers, config) {
        $scope.carriers = data.carriers;

        done();
      })
      .error(function (data, status, headers, config) {
        var error = (data && data.error) ?
          data.error :
          'There was a problem fetching the list of carriers.';

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

