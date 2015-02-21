var congoApp = angular.module('congoApp');

congoApp.controller('BenefitPlansNewController', [
  '$scope', '$http', '$location', 'propertiesFactory',
  function ($scope, $http, $location, propertiesFactory) {
    // Make sure user is totally signed up before continuing.
    $scope.enforceValidAccount();

    $scope.elements = [];
    $scope.carrierAccounts = null;
    $scope.selectedCarrierAccount = null;

    $scope.submit = function () {
      var properties = propertiesFactory.getPropertiesFromElements($scope.elements);

      $http
        .post('/api/v1/accounts/' + $scope.accountSlug() + '/roles/' + $scope.currentRole() + '/benefit_plans.json', {
          name: $scope.name,
          carrier_account_id: $scope.selectedCarrierAccount.id,
          properties: properties
        })
        .success(function (data, status, headers, config) {
          $location.path('/accounts/' + $scope.accountSlug() + '/' + $scope.currentRole() + '/benefit_plans');
        })
        .error(function (data, status, headers, config) {
          debugger
        });
    };

    function done () {
      if ($scope.elements && $scope.carrierAccounts) {
        $scope.ready();
      }
    }

    $http
      .get('/api/v1/accounts/' + $scope.accountSlug() + '/roles/' + $scope.currentRole() + '/properties/accounts.json')
      .success(function (data, status, headers, config) {
        $scope.elements = data.elements;

        done();
      })
      .error(function (data, status, headers, config) {
        debugger
      });

    $http
      .get('/api/v1/accounts/' + $scope.accountSlug() + '/roles/' + $scope.currentRole() + '/carrier_accounts.json')
      .success(function (data, status, headers, config) {
        $scope.carrierAccounts = data.carrier_accounts;
        $scope.selectedCarrierAccount = data.carrier_accounts[0];

        done();
      })
      .error(function (data, status, headers, config) {
        debugger
      });
  }
]);

