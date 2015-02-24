var congoApp = angular.module('congoApp');

congoApp.controller('AccountsEditController', [
  '$scope',
  '$location',
  '$http',
  function ($scope, $location, $http) {
    $scope.elements = [];

    $http
      .get('/api/v1/accounts/' + $scope.accountSlug() + '/roles/' + $scope.currentRole() + '/properties/accounts.json')
      .success(function (data, status, headers, config) {
        var currentAccount = $scope.currentAccount();
        var currentAccountProperties = JSON.parse(currentAccount.properties_data);

        $scope.elements = data.elements;
        $scope.planName = currentAccount.plan_name;

        _($scope.elements).each(function (element) {
          element.value = currentAccountProperties[element.name];
        });

        $scope.ready();
      })
      .error(function (data, status, headers, config) {
        debugger
      });
  }
]);

