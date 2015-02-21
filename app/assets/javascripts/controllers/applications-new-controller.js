var congoApp = angular.module('congoApp');

congoApp.controller('ApplicationsNewController', [
  '$scope', '$http', '$location', '$cookieStore',
  function ($scope, $http, $location, $cookieStore) {
    // Make sure user is totally signed up before continuing.
    $scope.enforceValidAccount();

    $scope.group = null;
    $scope.benefitPlan = null;

    $scope.submit = function () {
      var properties = _.reduce(
        $('#enrollment-form form').serializeArray(),
        function (sum, element) {
          sum[element.name] = element.value;
          return sum;
        },
        {}
      );

      var data = {
        group_slug: $scope.groupSlug(),
        benefit_plan_id: $scope.benefitPlanId(),
        properties: properties,
        applied_by_id: congo.currentUser.id
      };

      var id = $cookieStore.get('current-application-id');

      $http
        .put('/api/v1/accounts/' + $scope.accountSlug() + '/roles/' + $scope.currentRole() + '/applications/' + id  + '.json', data)
        .success(function (data, status, headers, config) {
          $cookieStore.remove('current-application-id');

          $location.path('/accounts/' + $scope.accountSlug() + '/' + $scope.currentRole());
        })
        .error(function (data, status, headers, config) {
          debugger
        });
    }

    function done () {
      if ($scope.group && $scope.benefitPlan) {
        $scope.ready();
      }
    }

    $http
      .get('/api/v1/accounts/' + $scope.accountSlug() + '/roles/' + $scope.currentRole() + '/groups/' + $scope.groupSlug() + '.json')
      .success(function (data, status, headers, config) {
        $scope.group = data.group;

        done();
      })
      .error(function (data, status, headers, config) {
        debugger
      });

    $http
      .get('/api/v1/accounts/' + $scope.accountSlug() + '/roles/' + $scope.currentRole() + '/benefit_plans/' + $scope.benefitPlanId() + '.json')
      .success(function (data, status, headers, config) {
        $scope.benefitPlan = data.benefit_plan;

        done();
      })
      .error(function (data, status, headers, config) {
        debugger
      });
  }
]);

