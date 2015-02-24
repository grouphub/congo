var congoApp = angular.module('congoApp');

congoApp.controller('AccountsEditController', [
  '$scope',
  '$location',
  '$http',
  'flashesFactory',
  function ($scope, $location, $http, flashesFactory) {
    $scope.elements = [];

    $scope.submit = function () {
      var data = _($scope.elements).reduce(function (hash, element) {
        hash[element.name] = element.value;
        return hash;
      }, {});

      data.plan_name = $scope.planName;

      console.log(data);

      $http
        .put('/api/v1/accounts/' + $scope.accountSlug() + '/roles/' + $scope.currentRole() + '.json', data)
        .success(function (data, status, headers, config) {
          flashesFactory.add('success', 'Successfully updated account!');

          congo.currentUser = data.user;
        })
        .error(function (data, status, headers, config) {
          debugger;
        })
    };

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

