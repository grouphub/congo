var congoApp = angular.module('congoApp');

congoApp.controller('UsersNewAccountController', [
  '$scope', '$http', '$location', 'propertiesFactory', 'flashesFactory',
  function ($scope, $http, $location, propertiesFactory, flashesFactory) {
    $scope.elements = [];

    $scope.submit = function () {
      var properties;
      var account;
      var accountId;
      var data;

      $scope.$broadcast('show-errors-check-validity');

      if ($scope.accountForm.$invalid) {
        return;
      }

      properties = propertiesFactory.getPropertiesFromElements($scope.elements);
      account = congo.currentUser.accounts[0] || {};
      accountId = account.id

      data = {
        account_id: accountId,
        account_properties: properties
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

    $http
      .get('/api/internal/accounts/' + $scope.accountSlug() + '/roles/' + $scope.currentRole() + '/properties/accounts.json')
      .success(function (data, status, headers, config) {
        $scope.elements = data.elements;

        $scope.ready();
      })
      .error(function (data, status, headers, config) {
        var error = (data && data.error) ?
          data.error :
          'There was a problem fetching accounts.';

        flashesFactory.add('danger', error);
      });
  }
]);

