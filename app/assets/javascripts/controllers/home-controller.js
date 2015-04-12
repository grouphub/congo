var congoApp = angular.module('congoApp');

congoApp.controller('HomeController', [
  '$scope',
  '$http',
  'flashesFactory',
  function ($scope, $http, flashesFactory) {
    if ($scope.currentRole() === 'broker' || $scope.currentRole() === 'group_admin') {
      $http.get('/api/internal/accounts/' + $scope.accountSlug() + '/roles/' + $scope.currentRole() + '/charts/members_status.json')
        .success(function (data, status, headers, config) {
          $scope.labels = data.labels;
          $scope.series = data.series;
          $scope.data = data.data;

          $scope.ready();
        })
        .error(function (data, status, headers, config) {
          var error = (data && data.error) ?
            data.error :
            'There was a problem loading the chart.';

          flashesFactory.add('danger', error);
        });
    } else {
      $scope.ready();
    }


    $scope.ready();
  }
]);

