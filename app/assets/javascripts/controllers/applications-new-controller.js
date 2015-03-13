var congoApp = angular.module('congoApp');

congoApp.controller('ApplicationsNewController', [
  '$scope', '$http', '$location', '$cookieStore',
  function ($scope, $http, $location, $cookieStore) {
    // Make sure user is totally signed up before continuing.
    $scope.enforceValidAccount();

    $scope.group = null;
    $scope.benefitPlan = null;

    $scope.getNumber = function (number) {
      var array = []
      var i = 0;

      for (; i < number; i++) {
        array.push(i);
      }

      return array;
    }

    $scope.addDependent = function () {
      var newDependent = {
        previousCoverage: 'No'
      }

      $scope.form.dependents.push(newDependent);

      $scope.form.numberOfDependents++;
    };

    $scope.removeDependent = function () {
      $scope.form.dependents.pop();

      if ($scope.form.numberOfDependents > 0) {
        $scope.form.numberOfDependents--;
      }
    };

    $scope.form = {
      previousCoverage: 'No',
      parentOrLegalGuardian: 'No',
      parentOrLegalGuardianSameAddress: 'Yes',
      authorizedRepresentative: 'No',
      numberOfDependents: 0,
      dependents: [],
    };

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
        .put('/api/internal/accounts/' + $scope.accountSlug() + '/roles/' + $scope.currentRole() + '/applications/' + id  + '.json', data)
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
      .get('/api/internal/accounts/' + $scope.accountSlug() + '/roles/' + $scope.currentRole() + '/groups/' + $scope.groupSlug() + '.json')
      .success(function (data, status, headers, config) {
        $scope.group = data.group;

        done();
      })
      .error(function (data, status, headers, config) {
        debugger
      });

    $http
      .get('/api/internal/accounts/' + $scope.accountSlug() + '/roles/' + $scope.currentRole() + '/benefit_plans/' + $scope.benefitPlanId() + '.json')
      .success(function (data, status, headers, config) {
        $scope.benefitPlan = data.benefit_plan;

        done();
      })
      .error(function (data, status, headers, config) {
        debugger
      });
  }
]);

