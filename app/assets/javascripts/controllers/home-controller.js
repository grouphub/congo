var congoApp = angular.module('congoApp');

congoApp.controller('HomeController', [
  '$scope',
  '$http',
  '$timeout',
  'flashesFactory',
  function ($scope, $http, $timeout, flashesFactory) {
    $scope.data = null;
    $scope.labels = null;
    $scope.series = null;
    $scope.chartReady = false;
    $scope.groups = null;

    function done () {
      if ($scope.currentRole() === 'admin') {
        $scope.ready();
      } else if ($scope.currentRole() === 'customer') {
        if ($scope.groups) {
          $scope.ready();
        }
      } else {
        if ($scope.groups && $scope.chartReady) {
          $scope.ready();
        }
      }
    }

    function reloadChart () {
      if ($scope.currentRole() === 'broker' || $scope.currentRole() === 'group_admin') {
        $http.get('/api/internal/accounts/' + $scope.accountSlug() + '/roles/' + $scope.currentRole() + '/charts/members_status.json')
          .success(function (data, status, headers, config) {
            $scope.chartReady = true;

            // TODO: I don't like this.
            $timeout(function () {
              $scope.labels = data.labels;
              $scope.series = data.series;
              $scope.data = data.data;
            }, 500);

            done();
          })
          .error(function (data, status, headers, config) {
            // Do nothing for now...
          });
      } else {
        done();
      }
    }

    $scope.$on('$locationChangeStart', reloadChart);
    reloadChart();

    // Load groups.
    if ($scope.currentRole() !== 'admin') {
      $http
        .get('/api/internal/accounts/' + $scope.accountSlug() + '/roles/' + $scope.currentRole() + '/groups.json')
        .success(function (data, status, headers, config) {
          $scope.groups = data.groups;

          done();
        })
        .error(function (data, status, headers, config) {
          var error = (data && data.error) ?
            data.error :
            'There was a problem fetching the list of groups.';

          flashesFactory.add('danger', error);
        });
    }
  }
]);

