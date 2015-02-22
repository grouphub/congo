var congoApp = angular.module('congoApp');

congoApp.controller('MessagesIndexController', [
  '$scope',
  function ($scope) {
    console.log('yes');
    $scope.ready();
  }
]);

