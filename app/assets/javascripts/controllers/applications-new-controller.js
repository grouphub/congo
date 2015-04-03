var congoApp = angular.module('congoApp');

congoApp.controller('ApplicationsNewController', [
  '$scope', '$http', '$location', '$cookieStore', 'flashesFactory',
  function ($scope, $http, $location, $cookieStore, flashesFactory) {
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

    $scope.employmentStatuses = [
      'Full-time',
      'Part-time',
      'Leave of Absence',
      'Terminated',
      'Retired',
      'Active',
      'Active Military - Overseas',
      'Active Military - USA'
    ];

    $scope.relationships = [
      'Spouse',
      'Father or Mother',
      'Grandfather or Grandmother',
      'Grandson or Granddaughter',
      'Uncle or Aunt',
      'Nephew or Niece',
      'Cousin',
      'Adopted Child',
      'Foster Child',
      'Son-in-law or Daughter-in-law',
      'Brother-in-law or Sister-in-law',
      'Mother-in-law or Father-in-law',
      'Brother or Sister',
      'Ward',
      'Stepparent',
      'Stepson or Stepdaughter',
      'Self',
      'Child',
      'Sponsored Dependent',
      'Dependent of a Minor Dependent',
      'Ex-spouse',
      'Guardian',
      'Court Appointed Guardian',
      'Collateral Dependent',
      'Life Partner',
      'Annuitant',
      'Trustee',
      'Other Relationship',
      'Other Relative'
    ];

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
        benefit_plan_slug: $scope.benefitPlanSlug(),
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
          var error = (data && data.error) ?
            data.error :
            'There was a problem updating the application.';

          flashesFactory.add('danger', error);
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
        var error = (data && data.error) ?
          data.error :
          'There was a problem fetching the group.';

        flashesFactory.add('danger', error);
      });

    $http
      .get('/api/internal/accounts/' + $scope.accountSlug() + '/roles/' + $scope.currentRole() + '/benefit_plans/' + $scope.benefitPlanSlug() + '.json')
      .success(function (data, status, headers, config) {
        $scope.benefitPlan = data.benefit_plan;

        done();
      })
      .error(function (data, status, headers, config) {
        var error = (data && data.error) ?
          data.error :
          'There was a problem fetching the benefit plan.';

        flashesFactory.add('danger', error);
      });
  }
]);

