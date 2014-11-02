var congoApp = angular.module('congoApp');

congoApp.factory('userDataFactory', function ($location, $cookieStore) {
  var userDataFactory = {
    drawerToggle: function () {
      $cookieStore.put('show-drawer', !$cookieStore.get('show-drawer'));
    },
    isDrawerShown: function () {
      return $cookieStore.get('show-drawer');
    },
    accountSlug: function () {
      var match = $location.path().match(/\/accounts\/([^\/]+)/);

      if (match && match[1] && match[1].length > 0) {
        return match[1];
      }
    },
    groupSlug: function () {
      var match = $location.path().match(/\/groups\/([^\/]+)/);

      if (match && match[1] && match[1].length > 0) {
        return match[1];
      }
    },
    productId: function () {
      var match = $location.path().match(/products\/([^\/])+/);

      if (match && match[1] && match[1].length > 0) {
        return match[1];
      }
    },
    userId: function () {
      var match = $location.path().match(/\/users\/(\d+)/);

      if (match && match[1] && match[1].length > 0) {
        return match[1];
      }
    },
    currentRole: function () {
      var match = $location.path().match(/\/accounts\/[^\/]+\/([^\/]+)/);

      if (match && match[1] && match[1].length > 0) {
        return match[1];
      }
    },
    isSignedin: function () {
      return !!congo.currentUser;
    },
    hasRole: function (name) {
      var currentUser = congo.currentUser;
      var accounts;
      var accountSlug;
      var account;

      if (!currentUser) {
        return;
      }

      accounts = currentUser.accounts;
      accountSlug = userDataFactory.accountSlug();
      account = _.find(accounts, function (account) {
        return account.slug === accountSlug && account.role.role === name;
      });

      if (!account) {
        return;
      }

      return true;
    },
    firstName: function () {
      if (!congo.currentUser) {
        return;
      }

      return congo.currentUser.first_name;
    },
    accounts: function () {
      if (!congo.currentUser) {
        return;
      }

      return congo.currentUser.accounts;
    },
    accountName: function () {
      var account;

      if (!congo.currentUser) {
        return;
      }

      account = _(congo.currentUser.accounts)
        .findWhere({ slug: userDataFactory.accountSlug() });

      if(!account) {
        return;
      }

      return account.name;
    },
    currentUserId: function () {
      if (!congo.currentUser) {
        return;
      }

      return congo.currentUser.id;
    }
  };

  return userDataFactory;
});

