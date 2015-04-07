var congoApp = angular.module('congoApp');

congoApp.directive('eligibilityModal', [
  '$http', '$timeout',
  function ($http, $timeout) {
    return {
      restrict: 'E',
      replace: true,
      templateUrl: congo.assets['directives/eligibility-modal.html'],
      link: function ($scope, $element, $attrs) {
        // Data that the user populates.
        $scope.eligibilityForm = {
          carrier_id: undefined,
          member_id: '',
          date_of_birth: '',
          first_name: '',
          last_name: ''
        };

        $scope.eligibilityFormSettings = {
          // Eligibility data from the response.
          eligibility: undefined,

          // List of carriers to populate the dropdown.
          carriers: [],

          // If an error occurs when submitting the form.
          error: undefined
        }

        // TODO: Using JQuery in a controller is poor style. Find a way to solve
        // this using $scope variables or a directive.
        $('body').delegate('[data-target="#eligibility-modal"]', 'click', function (e) {
          $scope.resetEligibilityForm();

          // TODO: Hacky!
          $timeout(function () {
            $('#date-of-birth').datepicker();
          }, 100);

          $http.get('/api/internal/accounts/' + $scope.accountSlug() + '/roles/' + $scope.currentRole() + '/carriers.json?only_activated=true')
            .then(
              function (response) {
                var carrier = response.data.carriers[0];

                $scope.eligibilityFormSettings.carriers = response.data.carriers;
                $scope.eligibilityForm.carrier_id = (carrier ? carrier.id : undefined);
              },
              function (response) {
                debugger;
              }
            );
        });

        $scope.submitEligibilityForm = function () {
          $scope.eligibilityFormSettings.error = undefined;

          $http.post('/api/internal/accounts/' + $scope.accountSlug() + '/roles/' + $scope.currentRole() + '/eligibilities.json', $scope.eligibilityForm)
            .then(
              function (response) {
                $scope.eligibilityFormSettings.eligibility = response.data.eligibility;
              },
              function (response) {
                var error = (response.data && response.data.error) ?
                  response.data.error :
                  'An error occurred. Please try submitting the form again.';

                $scope.eligibilityFormSettings.error = error;
              }
            );
        };

        $scope.resetEligibilityForm = function () {
          var carrier = $scope.eligibilityFormSettings.carriers[0];

          $scope.eligibilityFormSettings.eligibility = undefined;

          $scope.eligibilityForm.carrier_id = (carrier ? carrier.id : undefined);
          $scope.eligibilityForm.member_id = '';
          $scope.eligibilityForm.date_of_birth = '';
          $scope.eligibilityForm.first_name = '';
          $scope.eligibilityForm.last_name = '';
        };
      }
    };
  }
]);

