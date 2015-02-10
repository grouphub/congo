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
        $scope.form = {
          carrier_account_id: undefined,
          member_id: '',
          date_of_birth: '',
          first_name: '',
          last_name: ''
        };

        $scope.settings = {
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
          $scope.reset();

          $http.get('/api/v1/accounts/' + $scope.accountSlug() + '/roles/' + $scope.currentRole() + '/carrier_accounts.json')
            .then(
              function (response) {
                var carrierAccount = response.data.carrier_accounts[0];

                $scope.settings.carrier_accounts = response.data.carrier_accounts;
                $scope.form.carrier_account_id = (carrierAccount ? carrierAccount.id : undefined);
              },
              function (response) {
                debugger;
              }
            );
        });

        $scope.submit = function () {
          $scope.settings.error = undefined;

          $http.post('/api/v1/accounts/' + $scope.accountSlug() + '/roles/' + $scope.currentRole() + '/eligibilities.json', $scope.form)
            .then(
              function (response) {
                $scope.settings.eligibility = response.data.eligibility;
              },
              function (response) {
                $scope.settings.error = 'An error occurred. Please try submitting the form again.';
              }
            );
        };

        $scope.reset = function () {
          var carrierAccount = $scope.settings.carrier_accounts[0];

          $scope.settings.eligibility = undefined;

          $scope.form.carrier_account_id = (carrierAccount ? carrierAccount.id : undefined);
          $scope.form.member_id = '';
          $scope.form.date_of_birth = '';
          $scope.form.first_name = '';
          $scope.form.last_name = '';
        };

        _.defer(function () {
          $('#date-of-birth').datepicker();
        });
      }
    };
  }
]);

