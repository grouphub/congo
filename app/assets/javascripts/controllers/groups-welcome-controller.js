!function() {
  "use strict";

  angular.module('congoApp').controller('GroupsWelcomeController', GroupsWelcomeController);

  GroupsWelcomeController.$inject = ['$scope', '$http', '$location', '$sce', 'flashesFactory'];

  function GroupsWelcomeController($scope, $http, $location, $sce, flashesFactory){
    // Make sure user is totally signed up before continuing.
    $scope.enforceValidAccount();

    $scope.init = function(){
      $scope.ready();
    }
  }
}();
