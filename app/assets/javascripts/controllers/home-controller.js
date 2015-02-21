var congoApp = angular.module('congoApp');

congoApp.controller('HomeController', [
  '$scope',
  function ($scope) {
    $scope.ready();
  }
]);

