var congoApp = angular.module('congoApp');

congoApp.controller('ActivitiesIndexController', [
  '$scope',
  '$http',
  'flashesFactory',
  function ($scope, $http, flashesFactory) {
    $scope.notifications = [];

    $scope.markRead = function (notification) {
      console.log('Mark read', notification);
    };

    $scope.markUnread = function (notification) {
      console.log('Mark unread', notification);
    };

    $scope.destroy = function (notification) {
      console.log('Destroy', notification);
    };

    $scope.viewMore = function () {
      var oldestNotification = _($scope.notifications).last();

      $scope.isLoading = true;

      $http
        .get('/api/internal/accounts/' + $scope.accountSlug() + '/roles/' + $scope.currentRole() + '/notifications.json?limit=25&before=' + oldestNotification.created_at)
        .then(function (response) {
          $scope.notifications = $scope.notifications.concat(response.data.notifications);

          $scope.isLoading = false;
        })
        .catch(function (response) {
          var data = response.data;
          var error = (data && data.error) ?
            data.error :
            'There was a problem fetching notification count.';

          flashesFactory.add('danger', error);

          $scope.isLoading = false;
        });
    };

    $scope.reload = function () {
      $http
        .get('/api/internal/accounts/' + $scope.accountSlug() + '/roles/' + $scope.currentRole() + '/notifications.json?limit=25')
        .then(function (response) {
          $scope.notifications = response.data.notifications;

          $scope.isLoading = false;

          $scope.ready();
        })
        .catch(function (response) {
          var data = response.data;
          var error = (data && data.error) ?
            data.error :
            'There was a problem fetching notification count.';

          flashesFactory.add('danger', error);

          $scope.isLoading = false;
        });
    }

    $scope.isLoading = true;

    $scope.reload();
  }
]);

