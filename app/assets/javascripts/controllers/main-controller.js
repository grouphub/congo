var congoApp = angular.module('congoApp');

congoApp.controller('MainController', [
  '$scope',
  '$http',
  '$location',
  '$timeout',
  '$interval',
  '$q',
  '$routeParams',
  'userDataFactory',
  'flashesFactory',
  'eventsFactory',
  function ($scope, $http, $location, $timeout, $interval, $q, $routeParams, userDataFactory, flashesFactory, eventsFactory) {
    $scope.assets = congo.assets;

    // Loading behavior
    $scope.$on('$locationChangeStart', function(event) {
      // Scroll to top of page
      $('main').scrollTop(0);

      $scope.loading = true;
    });

    $scope.loading = true;
    $scope.ready = function () {
      $timeout(function () {
        $scope.loading = false;
      }, 250);
    };

    // Inject the userDataFactory methods onto MainController
    for (var key in userDataFactory) {
      $scope[key] = userDataFactory[key];
    }

    // Setup flashes
    eventsFactory.on($scope, 'flashes:changed', function (flashes) {
      $scope.flashes = flashes;
    });

    _(window.congo.flashes).each(function (flash) {
      flashesFactory.add(flash.type, flash.message);
    });

    // Update age of flashes
    $scope.$on('$locationChangeStart', function(event) {
      flashesFactory.update();
    });

    $('body').delegate('.alert', 'click', function (e) {
      var $me = $(this)
      var message = $me.find('.message').text();
      var type = $me.data('kind');

      flashesFactory.remove(type, message);

      // NOTE: Should not need to do this manually
      $me.remove();
    });

    // Assets path
    $scope.asset = function (path) {
      return congo.assets[path];
    };

    // Signout functionality
    $scope.signout = function () {
      $http
        .delete('/api/internal/users/signout.json')
        .success(function (data, status, headers, config) {
          congo.currentUser = null;

          $location.path('/');

          flashesFactory.add('success', 'You have signed out.');
        })
        .error(function (data, status, headers, config) {
          flashesFactory.add('danger', 'There was a problem signing you out');
        });
    };

    $scope.enforceValidAccount = function () {
      var currentAccount = _.findWhere(congo.currentUser.accounts, {
        slug: $scope.accountSlug()
      });

      if (!congo.currentUser) {
        flashesFactory.add('danger', 'You have to be signed in to continue.');
        $location.path('/users/sign_in');
      }

      if (!currentAccount) {
        flashesFactory.add('danger', 'We could not find an appropriate account.');
        $location.path('/');
      }

       debugger;
      if (!currentAccount.plan_name && !currentAccount.role.invitation_id) {
        flashesFactory.add('danger', 'Please choose a valid plan before continuing.');
        $location.path('/users/new_plan');
      }
    };

    $scope.enforceAdmin = function () {
      if (!congo.currentUser.is_admin) {
        flashesFactory.add('danger', 'You must be an admin to continue.');
        $location.path('/');
      }
    };

    // TODO: Change eligibility modal to use this format
    $scope.showReviewApplicationModal = function (application) {
    };

    $(function () {
      // Enable tooltips
      $('[data-toggle="tooltip"]').tooltip()
    });

    // Notifications system
    $interval(function () {
      if (!$scope.accountSlug() || !$scope.currentRole()) {
        return;
      }

      var url = '/api/internal/accounts/' + $scope.accountSlug() + '/roles/' + $scope.currentRole() + '/notifications/count.json';

      $http
        .get(url)
        .then(function (response) {
          var currentAccount = _(congo.currentUser.accounts).findWhere({ slug: $scope.accountSlug() });

          if (currentAccount) {
            currentAccount.activity_count = response.data.count;
          } else {
            // ...
          }
        })
        .catch(function (response) {
          // var data = response.data;
          // var error = (data && data.error) ?
          //   data.error :
          //   'There was a problem fetching notification count.';

          // flashesFactory.add('danger', error);
        });
    }, 5000);

    window.$congo = {}
    window.$congo.$mainControllerScope = $scope;
  }
]);

