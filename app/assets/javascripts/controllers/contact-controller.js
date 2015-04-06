var congoApp = angular.module('congoApp');

congoApp.controller('ContactController', [
  '$scope',
  '$location',
  function ($scope, $location) {
    $scope.ready();
  }
]);

