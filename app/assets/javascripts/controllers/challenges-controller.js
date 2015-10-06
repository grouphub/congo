var congoApp = angular.module('congoApp');

congoApp.controller('ChallengesController', [
  '$scope',
  '$location',
  function ($scope, $location) {
    $scope.ready();
  }
]);

