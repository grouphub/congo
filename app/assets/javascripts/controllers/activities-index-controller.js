var congoApp = angular.module('congoApp');

congoApp.controller('ActivitiesIndexController', [
  '$scope',
  '$http',
  'flashesFactory',
  function ($scope, $http, flashesFactory) {
    $scope.notifications = [];

    $scope.markRead = function (notification) {
      var data = {
        read_at: new Date().toISOString()
      }

      $http
        .put('/api/internal/accounts/' + $scope.accountSlug() + '/roles/' + $scope.currentRole() + '/notifications/' + notification.id + '.json', data)
        .then(function (response) {
          notification.read_at = response.data.notification.read_at;

          $scope.currentAccount().activity_count--;
        })
        .catch(function (response) {
          var data = response.data;
          var error = (data && data.error) ?
            data.error :
            'There was a problem marking the notification notification as read.';

          flashesFactory.add('danger', error);
        });
    };

    $scope.markUnread = function (notification) {
      var data = {
        unread_at: new Date().toISOString()
      }

      $http
        .put('/api/internal/accounts/' + $scope.accountSlug() + '/roles/' + $scope.currentRole() + '/notifications/' + notification.id + '.json', data)
        .then(function (response) {
          notification.read_at = response.data.notification.read_at;

          $scope.currentAccount().activity_count++;
        })
        .catch(function (response) {
          var data = response.data;
          var error = (data && data.error) ?
            data.error :
            'There was a problem marking the notification notification as unread.';

          flashesFactory.add('danger', error);
        });
    };

    $scope.destroy = function (notification) {
      $http
        .delete('/api/internal/accounts/' + $scope.accountSlug() + '/roles/' + $scope.currentRole() + '/notifications/' + notification.id + '.json')
        .then(function (response) {
          $scope.notifications = _($scope.notifications).reject(function (n) {
            return n.id === notification.id;
          });

          if (!notification.read_at) {
            $scope.currentAccount().activity_count--;
          }
        })
        .catch(function (response) {
          var data = response.data;
          var error = (data && data.error) ?
            data.error :
            'There was a problem deleting the notification.';

          flashesFactory.add('danger', error);
        });
    };

    $scope.viewMore = function () {
      var oldestNotification = _($scope.notifications).last();

      $http
        .get('/api/internal/accounts/' + $scope.accountSlug() + '/roles/' + $scope.currentRole() + '/notifications.json?limit=25&before=' + oldestNotification.created_at)
        .then(function (response) {
          $scope.notifications = $scope.notifications.concat(response.data.notifications);
        })
        .catch(function (response) {
          var data = response.data;
          var error = (data && data.error) ?
            data.error :
            'There was a problem fetching notification count.';

          flashesFactory.add('danger', error);
        });
    };

    $scope.markAllAsRead = function () {
      $http
        .put('/api/internal/accounts/' + $scope.accountSlug() + '/roles/' + $scope.currentRole() + '/notifications/mark_all_as_read.json')
        .then(function (response) {
          _($scope.notifications).each(function (notification) {
            notification.read_at = new Date().toISOString();
          });

          $scope.currentAccount().activity_count = 0;
        })
        .catch(function (response) {
          var data = response.data;
          var error = (data && data.error) ?
            data.error :
            'There was a problem marking all notifications as read.';

          flashesFactory.add('danger', error);
        });
    };

    $scope.reload = function () {
      $http
        .get('/api/internal/accounts/' + $scope.accountSlug() + '/roles/' + $scope.currentRole() + '/notifications.json?limit=25')
        .then(function (response) {
          $scope.notifications = response.data.notifications;

          $scope.ready();
        })
        .catch(function (response) {
          var data = response.data;
          var error = (data && data.error) ?
            data.error :
            'There was a problem fetching notification count.';

          flashesFactory.add('danger', error);
        });
    }

    $scope.reload();
  }
]);

