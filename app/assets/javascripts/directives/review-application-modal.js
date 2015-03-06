var congoApp = angular.module('congoApp');

congoApp.directive('reviewApplicationModal', [
  '$http',
  'eventsFactory',
  function ($http, eventsFactory) {
    return {
      restrict: 'E',
      replace: true,
      templateUrl: congo.assets['directives/review-application-modal.html'],
      link: function ($scope, $element, $attrs) {
        $scope.application = undefined;

        // TODO: Change eligibility modal to use this format
        $scope.vent.on($scope, 'review-application', function (application) {
          $scope.application = application;
          $scope.application.properties = JSON.parse($scope.application.properties_data);
        });
      }
    };
  }
]);


