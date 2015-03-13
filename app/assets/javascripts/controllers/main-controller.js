var congoApp = angular.module('congoApp');

congoApp.controller('MainController', [
  '$scope', '$http', '$location', '$timeout', 'userDataFactory', 'flashesFactory', 'eventsFactory',
  function ($scope, $http, $location, $timeout, userDataFactory, flashesFactory, eventsFactory) {
    // Expose an event emitter to all controllers for messaging
    $scope.vent = eventsFactory;

    $scope.assetPaths = congo.assetPaths;

    // Loading behavior
    $scope.$on('$locationChangeStart', function(event) {
      $scope.loading = true;
    });

    $scope.loading = true;
    $scope.ready = function () {
      $timeout(function () {
        $scope.loading = false;
      }, 100);
    };

    // Inject the userDataFactory methods onto MainController
    for (var key in userDataFactory) {
      $scope[key] = userDataFactory[key];
    }

    // Setup flashes
    $scope.vent.on($scope, 'flashes:changed', function (flashes) {
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

      if (!currentAccount.plan_name && !congo.currentUser.invitation_id) {
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

    window.$congo = {}
    window.$congo.$mainControllerScope = $scope;
  }
]);

