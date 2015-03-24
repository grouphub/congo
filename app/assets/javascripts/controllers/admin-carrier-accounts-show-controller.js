var congoApp = angular.module('congoApp');

congoApp.controller('AdminCarrierAccountsShowController', [
  '$scope', '$http', '$location', 'flashesFactory',
  function ($scope, $http, $location, flashesFactory) {
    // Make sure user is admin before continuing.
    $scope.enforceAdmin();

    $scope.carrierAccount = null;

    // ...
  }
]);

