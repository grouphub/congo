var congoApp = angular.module('congoApp');

congoApp.controller('LandingController', [
  '$scope',
  '$location',
  function ($scope, $location) {
    $scope.ready();
  }
]);

