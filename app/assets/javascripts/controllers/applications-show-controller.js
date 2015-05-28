var congoApp = angular.module('congoApp');

congoApp.controller('ApplicationsShowController', [
  '$scope', '$http', '$location', 'flashesFactory',
  function ($scope, $http, $location, flashesFactory) {
    // Make sure user is totally signed up before continuing.
    $scope.enforceValidAccount();

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

    $scope.application = null;
    $scope.form = null;

    $http
      .get('/api/internal/accounts/' + $scope.accountSlug() + '/roles/' + $scope.currentRole() + '/applications/' + $scope.applicationId() + '.json')
      .success(function (data, status, headers, config) {
        var application = data.application;

        // TODO: What's up with parent or legal guardian? Authorized Representative?
        (function () {
          var hasPreviousCoverage = false;
          var hasParentOrLegalGuardian = false;
          var hasParentOrLegalGuardianSameAddress = true;
          var hasAuthorizedRepresentative = false;
          var numberOfDependents = 0;
          var dependents = [];
          var keys;
          var properties = JSON.parse(application.properties_data);

          var i = 1;
          while (true) {
            if (properties['dependent_' + i.toString() + '_first_name']) {
              numberOfDependents++;
            } else {
              break;
            }

            i++;
          }

          if (properties.coverage_experience === 'Yes') {
            hasPreviousCoverage = true;
          }

          $scope.application = properties;

          $scope.form = {
            previousCoverage: (hasPreviousCoverage ? 'Yes' : 'No'),
            parentOrLegalGuardian: (hasParentOrLegalGuardian ? 'Yes' : 'No'),
            parentOrLegalGuardianSameAddress: (hasParentOrLegalGuardianSameAddress ? 'Yes' : 'No'),
            authorizedRepresentative: (hasAuthorizedRepresentative ? 'Yes' : 'No'),
            numberOfDependents: numberOfDependents,
            dependents: dependents
          }

          /* debugger */
        })();

        $scope.ready();
      })
      .error(function (data, status, headers, config) {
        var error = (data && data.error) ?
          data.error :
          'There was a problem fetching the application.';

        flashesFactory.add('danger', error);
      });
  }
]);

