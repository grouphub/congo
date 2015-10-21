var congoApp = angular.module('congoApp');

congoApp.directive('reviewApplicationModal', [
  '$http',
  '$sce',
  'eventsFactory',
  function ($http, $sce, eventsFactory) {
    return {
      restrict: 'E',
      replace: true,
      templateUrl: congo.assets['directives/review-application-modal.html'],
      link: function ($scope, $element, $attrs) {
        $scope.approveApplication = function (application) {
          var data = {
            approved_by_id: $scope.userId()
          }

          $http
            .put('/api/internal/accounts/' + $scope.accountSlug() + '/roles/' + $scope.currentRole() + '/applications/' + application.id + '.json', data)
            .success(function (data, status, headers, config) {
              var memberships = $scope.memberships();
              var membership = _(memberships).find(function (membership) {
                return _(membership.applications).find(function (application) {
                  return data.application.id === application.id;
                });
              });

              var application = _(membership.applications).find(function (application) {
                return data.application.id === application.id;
              });

              var applicationIndex = membership.applications.indexOf(application);

              membership.applications[applicationIndex] = data.application;

              $('#review-application-modal').modal('hide');
            })
            .error(function (data, status, headers, config) {
              debugger
            });
        };

        $scope.application = undefined;
        $scope.properties = undefined;
        $scope.memberships = undefined;

        // TODO: Change eligibility modal to use this format
        eventsFactory.on($scope, 'review-application', function (application, memberships) {
          $scope.application = application;
          $scope.properties  = JSON.parse($scope.application.properties_data);
          $scope.memberships = memberships;
          $scope.applicationPdfUrl = $sce.trustAsResourceUrl(application.pdf_attachment_url);
        });
      }
    };
  }
]);

