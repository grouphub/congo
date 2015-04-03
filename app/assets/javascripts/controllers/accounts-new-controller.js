var congoApp = angular.module('congoApp');

congoApp.controller('AccountsNewController', [
  '$scope',
  '$http',
  '$location',
  'flashesFactory',
  function ($scope, $http, $location, flashesFactory) {
    $scope.form = {
      name: null,
      tagline: null,
      tax_id: null,
      first_name: null,
      last_name: null,
      phone: null,
      plan_name: 'basic',
      card_number: null,
      month: null,
      year: null,
      cvc: null
    };

    $scope.submit = function () {
      var data = {
        properties: $scope.form
      };

      $http
        .post('/api/internal/accounts', data)
        .then(
          function (response) {
            flashesFactory.add('success', 'Successfully created account!');

            congo.currentUser = response.data.user;

            $location.path('/');
          },
          function (response) {
            var error = (response.data && response.data.error) ?
              response.data.error :
              'An error occurred. Please try creating an account again later.';

            flashesFactory.add('danger', error);
          }
        );
    };

    $scope.ready();
  }
]);

