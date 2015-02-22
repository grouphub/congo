var congoApp = angular.module('congoApp');

congoApp.controller('UsersNewAccountController', [
  '$scope', '$http', '$location', 'propertiesFactory', 'flashesFactory',
  function ($scope, $http, $location, propertiesFactory, flashesFactory) {
    $scope.elements = [];

    $scope.submit = function () {
      $scope.$broadcast('show-errors-check-validity');

      if ($scope.accountForm.$invalid) { return; }


      var properties = propertiesFactory.getPropertiesFromElements($scope.elements);
      var account = congo.currentUser.accounts[0] || {};
      var accountId = account.id

      var data = {
        account_id: accountId,
        account_properties: properties
      };

      $http
        .put('/api/v1/users/' + congo.currentUser.id + '.json', data)
        .success(function (data, status, headers, config) {
          var account;

          congo.currentUser = data.user;

          account = congo.currentUser.accounts[0];

          $location.path('/accounts/' + account.slug + '/' + account.role.name);

          flashesFactory.add('success', 'Welcome, ' + congo.currentUser.first_name + ' ' + congo.currentUser.last_name + '!');
        })
        .error(function (data, status, headers, config) {
          flashesFactory.add('danger', 'There was a problem creating your account.');
        });
    };

    $http
      .get('/api/v1/accounts/' + $scope.accountSlug() + '/roles/' + $scope.currentRole() + '/properties/accounts.json')
      .success(function (data, status, headers, config) {
        $scope.elements = data.elements;

        $scope.ready();
      })
      .error(function (data, status, headers, config) {
        debugger
      });
  }
]);

