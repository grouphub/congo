var congoApp = angular.module('congoApp');

congoApp.directive('eligibilityModal', [
  '$http',
  function ($http) {
    return {
      restrict: 'E',
      replace: true,
      templateUrl: congo.assets['directives/eligibility-modal.html'],
      link: function ($scope, $element, $attrs) {
        $scope.form = {
          // TODO: Populate this
          carriers: [],

          carrier: '',
          member_id: '',
          date_of_birth: '',
          first_name: '',
          last_name: ''
        };

        $http.get('/api/v1/accounts/' + $scope.accountSlug() + '/roles/' + $scope.currentRole() + '/carrier_accounts.json')
          .success(function (data, status, headers, config) {
            $scope.form.carriers = _.map(data.carrier_accounts, function (carrierAccount) {
              return {
                label: carrierAccount.name,
                value: carrierAccount.id
              };
            })
          })
          .error(function (data, status, headers, config) {

          });

        $scope.submit = function () {
          debugger

          $http.post('/api/v1/accounts/' + $scope.accountSlug() + '/roles/' + $scope.currentRole() + '/eligibilities', $scope.form)
            .success(function (data, status, headers, config) {

            })
            .error(function (data, status, headers, config) {

            });
        }

        $('#date-of-birth').datepicker();
      }
    };
  }
]);

