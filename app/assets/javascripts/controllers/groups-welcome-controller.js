var congoApp = angular.module('congoApp');

congoApp.controller('GroupsWelcomeController', [
  '$scope', '$http', '$location', '$sce', 'flashesFactory',
  function ($scope, $http, $location, $sce, flashesFactory) {
    $scope.ready();
  }
]);
