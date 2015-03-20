var congoApp = angular.module('congoApp');

congoApp.controller('UsersNewAccountController', [
  '$scope', '$http', '$location', 'flashesFactory',
  function ($scope, $http, $location, flashesFactory) {
    $scope.form = {
      name: null,
      tagline: null,
      tax_id: null,
      first_name: null,
      last_name: null,
      phone: null
    };

    $scope.submit = function () {
      var account;
      var accountId;
      var data;

      account = congo.currentUser.accounts[0] || {};
      accountId = account.id

      data = {
        account_id: accountId,
        account_properties: $scope.form
      };

      $http
        .put('/api/internal/users/' + congo.currentUser.id + '.json', data)
        .success(function (data, status, headers, config) {
          var account;

          congo.currentUser = data.user;

          account = congo.currentUser.accounts[0];

          $location.path('/accounts/' + account.slug + '/' + account.role.name);

          flashesFactory.add('success', 'Welcome, ' + congo.currentUser.first_name + ' ' + congo.currentUser.last_name + '!');
        })
        .error(function (data, status, headers, config) {
          var error = (data && data.error) ?
            data.error :
            'There was a problem creating your account.';

          flashesFactory.add('danger', error);
        });
    };

    $scope.ready();
  }
]);

