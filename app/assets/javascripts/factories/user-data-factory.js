var congoApp = angular.module('congoApp');

congoApp.factory('userDataFactory', [
  '$location', '$cookieStore',
  function ($location, $cookieStore) {
    var userDataFactory = {
      drawerToggle: function () {
        $cookieStore.put('show-drawer', !$cookieStore.get('show-drawer'));
      },
      isDrawerShown: function () {
        if (!congo.currentUser) {
          return true;
        }

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
      carrierAccountId: function () {
        var match = $location.path().match(/carrier_accounts\/([^\/])+/);

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
      applicationId: function () {
        var match = $location.path().match(/applications\/([^\/])+/);

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
        var match;

        match = $location.path().match(/^\/admin/);

        if (match) {
          return 'admin';
        }

        match = $location.path().match(/\/accounts\/[^\/]+\/([^\/]+)/);

        if (match && match[1] && match[1].length > 0) {
          return match[1];
        }
      },
      isGroupAdmin: function () {
        switch (userDataFactory.currentRole()) { 
          case "broker":
          case "group_admin":
            return true;
            break;
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
      userId: function () {
        if (!congo.currentUser) {
          return;
        }

        return congo.currentUser.id;
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

        return _.select(congo.currentUser.accounts, function (account) {
          return (account.slug && account.slug.length)
        });
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
      },
      isBrokerIncomplete: function () {
        var brokerAccounts = _.select(congo.currentUser.accounts, function (account) {
          return account.role === 'Broker';
        });

        var emptyBrokerAccounts = _.select(brokerAccounts, function (account) {
          return (!account.slug || account.slug.length === 0);
        });

        return emptyBrokerAccounts.length > 0;
      }
    };

    return userDataFactory;
  }
]);

