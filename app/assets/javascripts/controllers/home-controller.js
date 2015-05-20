var congoApp = angular.module('congoApp');

congoApp.controller('HomeController', [
  '$scope',
  '$http',
  '$timeout',
  'flashesFactory',
  function ($scope, $http, $timeout, flashesFactory) {
    function reloadChart () {
      if ($scope.currentRole() === 'broker' || $scope.currentRole() === 'group_admin') {
        $http.get('/api/internal/accounts/' + $scope.accountSlug() + '/roles/' + $scope.currentRole() + '/charts/members_status.json')
          .success(function (data, status, headers, config) {
            // TODO: I don't like this.
            $timeout(function () {
              $scope.labels = data.labels;
              $scope.series = data.series;
              $scope.data = data.data;

              $scope.ready();
            }, 100);
          })
          .error(function (data, status, headers, config) {
            // Do nothing for now...
          });
      } else {
        $scope.ready();
      }
    }

    $scope.$on('$locationChangeStart', reloadChart);
    reloadChart();
  }
]);

