var congoApp = angular.module('congoApp');

congoApp.controller('AdminCarrierAccountsIndexController', [
  '$scope', '$http', '$location', 'flashesFactory',
  function ($scope, $http, $location, flashesFactory) {
    // Make sure user is admin before continuing.
    $scope.enforceAdmin();

    $scope.carrierAccounts = null;

    $scope.ready();

    // ...
  }
]);

