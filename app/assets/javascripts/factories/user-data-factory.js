var congoApp = angular.module('congoApp');

congoApp.factory('userDataFactory', [
  '$location', '$cookieStore', '$routeParams',
  function ($location, $cookieStore, $routeParams) {
    function isSignedIn () {
      return !!congo.currentUser;
    }

    function currentRole () {
      var match;

      match = $location.path().match(/^\/admin/);

      if (match) {
        return 'admin';
      }

      return $routeParams.role;
    }

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
        return $routeParams.slug;
      },
      groupSlug: function () {
        return $routeParams.group_slug;
      },
      carrierSlug: function () {
        return $routeParams.carrier_slug;
      },
      carrierAccountId: function () {
        return $routeParams.carrier_account_id;
      },
      benefitPlanSlug: function () {
        return $routeParams.benefit_plan_slug;
      },
      applicationId: function () {
        return $routeParams.application_id;
      },
      userId: function () {
        return $routeParams.id;
      },
      currentRole: currentRole,
      isGroupAdmin: function () {
        switch (userDataFactory.currentRole()) { 
          case "broker":
          case "group_admin":
            return true;
            break;
        }
      },
      isSignedin: isSignedIn,
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

        if (!currentRole && inAdmin && currentUser.is_admin) {
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
      groups: function () {
         if (!congo.currentUser) {
           return;
         }

         return _.select(congo.currentUser.groups, function (group) {
           return (group.slug && group.slug.length)
         });
       },
      currentAccount: function () {
        var match;
        var account;

        if (!congo.currentUser) {
          return;
        }

        match = $location.path().match(/\/accounts\/([^\/]+)/);

        if (match && match[1] && match[1].length > 0) {
          account = _(congo.currentUser.accounts).findWhere({ slug: match[1] });
        }

        return account;
      },
      activityCount: function () {
        var match;
        var account;

        if (!congo.currentUser) {
          return;
        }

        match = $location.path().match(/\/accounts\/([^\/]+)/);

        if (match && match[1] && match[1].length > 0) {
          account = _(congo.currentUser.accounts).findWhere({ slug: match[1] });
        }

        if (!account) {
          return;
        }

        return account.activity_count;
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
      featureEnabled: function (featureName) {
        var account;

        if (!congo.currentUser) {
          return;
        }

        account = _(congo.currentUser.accounts)
          .findWhere({ slug: userDataFactory.accountSlug() });

        if (!account) {
          return;
        }

        if (!account.enabled_features) {
          return;
        }

        return _(account.enabled_features).contains(featureName);
      },
      isBrokerIncomplete: function () {
        var brokerAccounts = _.select(congo.currentUser.accounts, function (account) {
          return account.role === 'Broker';
        });

        var emptyBrokerAccounts = _.select(brokerAccounts, function (account) {
          return (!account.slug || account.slug.length === 0);
        });

        return emptyBrokerAccounts.length > 0;
      },
      hasBrokerAccount: function () {
        return JSON.parse(congo.currentUser.properties_data).is_broker;
      },
      shouldShowSidebar: function () {
        if (!isSignedIn()) {
          return false;
        }

        if (!currentRole()) {
          return false;
        }


        return true;
      },
      monetize: function (cents) {
        var dollars = Math.floor(cents / 100);
        var remainingCents = (cents % 100).toString();

        if (remainingCents.length === 0) {
          remainingCents = '00';
        } else if(remainingCents.length === 1) {
          remainingCents = '0' + remainingCents;
        }

        return ['$', dollars.toString(), '.', remainingCents.toString()].join('');
      }
    };

    return userDataFactory;
  }
]);

