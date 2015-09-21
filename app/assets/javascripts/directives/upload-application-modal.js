!function() {
  "use strict";
  angular.module('congoApp').
    directive('uploadApplicationModal', uploadApplicationModal);

  uploadApplicationModal.$inject = [ '$http', '$location', 'flashesFactory' ];

  function uploadApplicationModal() {
    return {
      restrict: 'E',
      replace: true,
      templateUrl: congo.assets['directives/upload-application-modal.html'],
      controller: 'UploadApplicationModalController'
    };
  }
}();
