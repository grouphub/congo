var congoApp = angular.module('congoApp');

congoApp.controller('AccountsController', [
  '$scope',
  '$location',
  function ($scope, $location) {
    $scope.ready();
  }
]);

