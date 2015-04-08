var congoApp = angular.module('congoApp');

congoApp.directive('descriptionModal', [
  '$http',
  '$sce',
  '$timeout',
  'eventsFactory',
  function ($http, $sce, $timeout, eventsFactory) {
    return {
      restrict: 'E',
      replace: true,
      templateUrl: congo.assets['directives/description-modal.html'],
      link: function ($scope, $element, $attrs) {
        $scope.description_trusted = null;

        // TODO: Change eligibility modal to use this format
        eventsFactory.on($scope, 'description', function (item) {
          var properties = JSON.parse(item.properties_data);
          var html = properties.description_html;

          $timeout(function () {
            $('#description-modal .modal-body a').attr('target', '_blank');
          }, 100);

          $scope.description_trusted = $sce.trustAsHtml(html);
        });
      }
    };
  }
]);

