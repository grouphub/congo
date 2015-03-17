var congoApp = angular.module('congoApp');

congoApp.controller('AccountsEditController', [
  '$scope',
  '$location',
  '$http',
  'flashesFactory',
  function ($scope, $location, $http, flashesFactory) {
    var currentAccount = $scope.currentAccount();

    $scope.form = {
      name: null,
      tagline: null,
      tax_id: null,
      first_name: null,
      last_name: null,
      phone: null,
      plan_type: null
    };

    $scope.submit = function () {
      var data = {
        properties: $scope.form
      };

      $http
        .put('/api/internal/accounts/' + $scope.accountSlug() + '/roles/' + $scope.currentRole() + '.json', data)
        .success(function (data, status, headers, config) {
          flashesFactory.add('success', 'Successfully updated account!');

          congo.currentUser = data.user;
        })
        .error(function (data, status, headers, config) {
          var error = (data && data.error) ?
            data.error :
            'There was a problem setting up your plan.';

          flashesFactory.add('danger', error);
        })
    };

    $scope.form = JSON.parse(currentAccount.properties_data);

    $scope.ready();
  }
]);

