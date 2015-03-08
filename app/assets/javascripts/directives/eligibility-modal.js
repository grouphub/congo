var congoApp = angular.module('congoApp');

congoApp.directive('eligibilityModal', [
  '$http',
  function ($http) {
    return {
      restrict: 'E',
      replace: true,
      templateUrl: congo.assets['directives/eligibility-modal.html'],
      link: function ($scope, $element, $attrs) {
        // Data that the user populates.
        $scope.eligibilityForm = {
          carrier_account_id: undefined,
          member_id: '',
          date_of_birth: '',
          first_name: '',
          last_name: ''
        };

        $scope.eligibilityFormSettings = {
          // Eligibility data from the response.
          eligibility: undefined,

          // List of carrier accounts to populate the dropdown.
          carrier_accounts: [],

          // If an error occurs when submitting the form.
          error: undefined
        }

        // TODO: Using JQuery in a controller is poor style. Find a way to solve
        // this using $scope variables or a directive.
        $('body').delegate('[data-target="#eligibility-modal"]', 'click', function (e) {
          $scope.resetEligibilityForm();

          $('#date-of-birth').datepicker();

          $http.get('/api/v1/accounts/' + $scope.accountSlug() + '/roles/' + $scope.currentRole() + '/carrier_accounts.json')
            .then(
              function (response) {
                var carrierAccount = response.data.carrier_accounts[0];

                $scope.eligibilityFormSettings.carrier_accounts = response.data.carrier_accounts;
                $scope.eligibilityForm.carrier_account_id = (carrierAccount ? carrierAccount.id : undefined);
              },
              function (response) {
                debugger;
              }
            );
        });

        $scope.submitEligibilityForm = function () {
          $scope.eligibilityFormSettings.error = undefined;

          $http.post('/api/v1/accounts/' + $scope.accountSlug() + '/roles/' + $scope.currentRole() + '/eligibilities.json', $scope.form)
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
          var carrierAccount = $scope.eligibilityFormSettings.carrier_accounts[0];

          $scope.eligibilityFormSettings.eligibility = undefined;

          $scope.eligibilityForm.carrier_account_id = (carrierAccount ? carrierAccount.id : undefined);
          $scope.eligibilityForm.member_id = '';
          $scope.eligibilityForm.date_of_birth = '';
          $scope.eligibilityForm.first_name = '';
          $scope.eligibilityForm.last_name = '';
        };
      }
    };
  }
]);

