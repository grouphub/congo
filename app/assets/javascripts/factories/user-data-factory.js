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
    carrierSlug: function () {
      var match = $location.path().match(/\/carriers\/([^\/]+)/);

      if (match && match[1] && match[1].length > 0) {
        return match[1];
      }
    },
    accountCarrierId: function () {
      var match = $location.path().match(/account_carriers\/([^\/])+/);

      if (match && match[1] && match[1].length > 0) {
        return match[1];
      }
    },
    benefitPlanId: function () {
      var match = $location.path().match(/benefit_plans\/([^\/])+/);

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
    isAdmin: function () {
      var currentUser = congo.currentUser;

      if (!currentUser) {
        return;
      }

      return currentUser.is_admin;
    },
    inAdminPanel: function () {
      var currentUser = congo.currentUser;
      var inAdmin = $location.path().match(/^\/admin/);
      var currentUserMatch = $location.path().match(/\/accounts\/[^\/]+\/([^\/]+)/);
      var currentRole = currentUserMatch && currentUserMatch[1] && currentUserMatch[1].length > 0;

      if (!currentUser) {
        return;
      }

      if (
        !currentRole &&
        inAdmin &&
        currentUser.is_admin
      ) {
        return true; 
      }
    },
    hasRole: function (name) {
      var currentUser = congo.currentUser;
      var accounts;
      var accountSlug;
      var account;
      var match = $location.path().match(/\/accounts\/[^\/]+\/([^\/]+)/);
      var currentRole = match && match[1] && match[1].length > 0;

      if (!currentUser) {
        return;
      }

      if (
        !currentRole &&
        name === 'admin' &&
        currentUser.is_admin
      ) {
        return true; 
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

