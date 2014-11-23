var congoApp = angular.module('congoApp', ['ngRoute', 'ngCookies']);

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
        .delete('/api/v1/users/signout.json')
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
  }
]);

congoApp.controller('LandingController', [
  '$scope',
  function ($scope) {
    $scope.ready();
  }
]);

congoApp.controller('HomeController', [
  '$scope',
  function ($scope) {
    $scope.ready();
  }
]);

congoApp.controller('UsersSigninController', [
  '$scope','$http', '$location', 'flashesFactory',
  function ($scope, $http, $location, flashesFactory) {
    $scope.submit = function () {
      $http
        .post('/api/v1/users/signin.json', {
          email: $scope.email,
          password: $scope.password
        })
        .success(function (data, status, headers, config) {
          congo.currentUser = data.user;

          $location.path('/');

          flashesFactory.add('success', 'Welcome back, ' + congo.currentUser.first_name + ' ' + congo.currentUser.last_name + '!');
        })
        .error(function (data, status, headers, config) {
          flashesFactory.add('danger', 'There was a problem signing you in.');
        });
    };

    $scope.ready();
  }
]);

congoApp.controller('UsersNewManagerController', [
  '$scope', '$http', '$location', 'flashesFactory',
  function ($scope, $http, $location, flashesFactory) {
    $scope.submit = function () {
      $http
        .post('/api/v1/users.json', {
          first_name: $scope.first_name,
          last_name: $scope.last_name,
          email: $scope.email,
          password: $scope.password,
          password_confirmation: $scope.password_confirmation,
          type: 'broker'
        })
        .success(function (data, status, headers, config) {
          congo.currentUser = data.user;

          $location.path('/users/new_plan');
        })
        .error(function (data, status, headers, config) {
          flashesFactory.add('danger', 'There was a problem creating your account.');
        });
    };

    $scope.ready();
  }
]);

congoApp.controller('UsersNewPlanController', [
  '$scope', '$http', '$location', 'flashesFactory',
  function ($scope, $http, $location, flashesFactory) {
    $scope.pickPlan = function (planName) {
      $http
        .put('/api/v1/users/' + congo.currentUser.id + '.json', {
          plan_name: planName
        })
        .success(function (data, status, headers, config) {
          $location.path('/users/new_billing');
        })
        .error(function (data, status, headers, config) {
          flashesFactory.add('danger', 'There was a problem setting up your plan.');
        });
    };

    $scope.addInviteCode = function () {
      $http
        .put('/api/v1/users/' + congo.currentUser.id + '.json', {
          invite_code: $scope.invitation
        })
        .success(function (data, status, headers, config) {
          $location.path('/users/new_account');
        })
        .error(function (data, status, headers, config) {
          flashesFactory.add('danger', 'There was a problem setting up your plan.');
        });
    };

    $scope.ready();
  }
]);

congoApp.controller('UsersNewBillingController', [
  '$scope', '$http', '$location',
  function ($scope, $http, $location) {
    $scope.submit = function () {
      $http
        .put('/api/v1/users/' + congo.currentUser.id + '.json', {
          user_properties: {
            card_number: $scope.cardNumber,
            month: $scope.month,
            year: $scope.year,
            cvc: $scope.cvc
          }
        })
        .success(function (data, status, headers, config) {
          $location.path('/users/new_account');
        })
        .error(function (data, status, headers, config) {
          flashesFactory.add('danger', 'There was a problem setting up your payment info.');
        });
    };

    $scope.ready();
  }
]);

congoApp.controller('UsersNewAccountController', [
  '$scope', '$http', '$location', 'propertiesFactory',
  function ($scope, $http, $location, propertiesFactory) {
    $scope.elements = [];

    $scope.submit = function () {
      var properties = propertiesFactory.getPropertiesFromElements($scope.elements);
      var account = congo.currentUser.accounts[0] || {};
      var accountId = account.id

      var data = {
        account_id: accountId,
        account_properties: properties
      };

      $http
        .put('/api/v1/users/' + congo.currentUser.id + '.json', data)
        .success(function (data, status, headers, config) {
          var account;

          congo.currentUser = data.user;

          account = congo.currentUser.accounts[0];

          $location.path('/accounts/' + account.slug + '/' + account.role.name);

          flashesFactory.add('success', 'Welcome, ' + congo.currentUser.first_name + ' ' + congo.currentUser.last_name + '!');
        })
        .error(function (data, status, headers, config) {
          flashesFactory.add('danger', 'There was a problem creating your account.');
        });
    };

    $http
      .get('/api/v1/accounts/' + $scope.accountSlug() + '/roles/' + $scope.currentRole() + '/properties/accounts.json')
      .success(function (data, status, headers, config) {
        $scope.elements = data.elements;

        $scope.ready();
      })
      .error(function (data, status, headers, config) {
        debugger
      });
  }
]);

congoApp.controller('UsersNewCustomerController', [
  '$scope', '$http', '$location',
  function ($scope, $http, $location) {
    var emailToken = $location.search().email_token;

    congo.currentUser = null;

    $scope.signin = function () {
      var email = $scope.signin_email;
      var password = $scope.signin_password;

      $http
        .post('/api/v1/users/signin.json', {
          email: email,
          password: password,
          email_token: emailToken
        })
        .success(function (data, status, headers, config) {
          congo.currentUser = data.user;

          $location.path('/');
        })
        .error(function (data, status, headers, config) {
          debugger
        });
    }

    $scope.signup = function () {
      $http
        .post('/api/v1/users.json', {
          first_name: $scope.first_name,
          last_name: $scope.last_name,
          email: $scope.email,
          password: $scope.password,
          password_confirmation: $scope.password_confirmation,
          email_token: emailToken
        })
        .success(function (data, status, headers, config) {
          congo.currentUser = data.user;

          $location.path('/');
        })
        .error(function (data, status, headers, config) {
          debugger
        });
    };

    $scope.ready();
  }
]);

congoApp.controller('UsersShowController', [
  '$scope', '$http', '$location',
  function ($scope, $http, $location) {
    $scope.user = null;

    $scope.$watch('user');

    $http
      .get('/api/v1/users/' + $scope.userId() + '.json')
      .success(function (data, status, headers, config) {
        $scope.user = data.user;

        $scope.ready();
      })
      .error(function (data, status, headers, config) {
        debugger
      });
  }
]);

congoApp.controller('CarriersNewController', [
  '$scope', '$http', '$location', 'propertiesFactory',
  function ($scope, $http, $location, propertiesFactory) {
    $scope.elements = [];

    $scope.submit = function () {
      var properties = propertiesFactory.getPropertiesFromElements($scope.elements);

      $http
        .post('/api/v1/carriers.json', {
          name: $scope.name,
          properties: properties
        })
        .success(function (data, status, headers, config) {
          $location.path('/admin/carriers');
        })
        .error(function (data, status, headers, config) {
          debugger
        });
    };

    $http
      .get('/api/v1/accounts/' + $scope.accountSlug() + '/roles/' + $scope.currentRole() + '/properties/carriers.json')
      .success(function (data, status, headers, config) {
        $scope.elements = data.elements;

        $scope.ready();
      })
      .error(function (data, status, headers, config) {
        debugger
      });
  }
]);

congoApp.controller('CarriersIndexController', [
  '$scope', '$http', '$location',
  function ($scope, $http, $location) {
    // Make sure user is admin before continuing.
    $scope.enforceAdmin();

    $http
      .get('/api/v1/carriers.json')
      .success(function (data, status, headers, config) {
        $scope.carriers = data.carriers;

        $scope.ready();
      })
      .error(function (data, status, headers, config) {
        debugger
      });
  }
]);

congoApp.controller('CarriersShowController', [
  '$scope', '$http', '$location',
  function ($scope, $http, $location) {
    // Make sure user is admin before continuing.
    $scope.enforceAdmin();

    $http
      .get('/api/v1/carriers/' + $scope.carrierSlug() + '.json')
      .success(function (data, status, headers, config) {
        $scope.carrier = data.carrier;

        $scope.ready();
      })
      .error(function (data, status, headers, config) {
        debugger
      });
  }
]);

congoApp.controller('InvitationsIndexController', [
  '$scope', '$http', '$location',
  function ($scope, $http, $location) {
    // Make sure user is admin before continuing.
    $scope.enforceAdmin();

    $scope.invitations = [];

    $scope.deleteInvitation = function (invitationId) {
      $http
        .delete('/api/v1/invitations/' + invitationId + '.json')
        .success(function (data, status, headers, config) {
          $scope.invitations = _($scope.invitations).reject(function (invitation) {
            return invitation.id === invitationId; 
          });
        })
        .error(function (data, status, headers, config) {
          debugger
        });
    };

    $scope.newInvitation = function () {
      $http
        .post('/api/v1/invitations.json', {
          description: $scope.description     
        })
        .success(function (data, status, headers, config) {
          $scope.invitations.push(data.invitation);
          $scope.description = '';
        })
        .error(function (data, status, headers, config) {
          debugger
        });
    };

    $http
      .get('/api/v1/invitations.json')
      .success(function (data, status, headers, config) {
        $scope.invitations = data.invitations;

        $scope.ready();
      })
      .error(function (data, status, headers, config) {
        debugger
      });
  }
]);

congoApp.controller('CarrierAccountsIndexController', [
  '$scope', '$http', '$location',
  function ($scope, $http, $location) {
    // Make sure user is totally signed up before continuing.
    $scope.enforceValidAccount();

    $scope.carrierAccounts = null;

    $scope.deleteCarrierAccountAt = function (index) {
      var carrierAccount = $scope.carrierAccounts[index];

      if (!carrierAccount) {
        debugger
      }

      $http
        .delete('/api/v1/accounts/' + $scope.accountSlug() + '/roles/' + $scope.currentRole() + '/carrier_accounts/' + carrier_account.id + '.json')
        .success(function (data, status, headers, config) {
          $scope.carrierAccounts.splice(index, 1);
        })
        .error(function (data, status, headers, config) {
          debugger
        });
    };

    $http
      .get('/api/v1/accounts/' + $scope.accountSlug() + '/roles/' + $scope.currentRole() + '/carrier_accounts.json')
      .success(function (data, status, headers, config) {
        $scope.carrierAccounts = data.carrier_accounts;

        $scope.ready();
      })
      .error(function (data, status, headers, config) {
        debugger
      });
  }
]);

congoApp.controller('CarrierAccountsNewController', [
  '$scope', '$http', '$location', 'propertiesFactory',
  function ($scope, $http, $location, propertiesFactory) {
    // Make sure user is totally signed up before continuing.
    $scope.enforceValidAccount();

    $scope.elements = [];
    $scope.carriers = [];
    $scope.selectedCarrier = null;

    $scope.submit = function () {
      var properties = propertiesFactory.getPropertiesFromElements($scope.elements);

      $http
        .post('/api/v1/accounts/' + $scope.accountSlug() + '/roles/' + $scope.currentRole() + '/carrier_accounts.json', {
          name: $scope.name,
          carrier_slug: $scope.selectedCarrier.slug,
          properties: properties
        })
        .success(function (data, status, headers, config) {
          $location.path('/accounts/' + $scope.accountSlug() + '/' + $scope.currentRole() + '/carrier_accounts');
        })
        .error(function (data, status, headers, config) {
          debugger
        });
    };

    function done () {
      if ($scope.elements && $scope.carriers) {
        $scope.ready();
      }
    }

    $http
      .get('/api/v1/accounts/' + $scope.accountSlug() + '/roles/' + $scope.currentRole() + '/properties/carrier_accounts.json')
      .success(function (data, status, headers, config) {
        $scope.elements = data.elements;

        done();
      })
      .error(function (data, status, headers, config) {
        debugger
      });

    $http
      .get('/api/v1/carriers.json')
      .success(function (data, status, headers, config) {
        $scope.carriers = data.carriers;
        $scope.selectedCarrier = data.carriers[0];

        done();
      })
      .error(function (data, status, headers, config) {
        debugger
      });
  }
]);

congoApp.controller('CarrierAccountsShowController', [
  '$scope', '$http', '$location',
  function ($scope, $http, $location) {
    // Make sure user is totally signed up before continuing.
    $scope.enforceValidAccount();

    $scope.carrierAccount = null;

    $http
      .get('/api/v1/accounts/' + $scope.accountSlug() + '/roles/' + $scope.currentRole() + '/carrier_accounts/' + $scope.carrierAccountId() + '.json')
      .success(function (data, status, headers, config) {
        $scope.carrierAccount = data.carrier_account;

        $scope.ready();
      })
      .error(function (data, status, headers, config) {
        debugger
      });
  }
]);

congoApp.controller('BenefitPlansIndexController', [
  '$scope', '$http', '$location',
  function ($scope, $http, $location) {
    // Make sure user is totally signed up before continuing.
    $scope.enforceValidAccount();

    $scope.toggleBenefitPlanAt = function (index) {
      var benefitPlan = $scope.benefitPlans[index];

      if (!benefitPlan) {
        debugger
      }

      console.log(benefitPlan.is_enabled);

      $http
        .put('/api/v1/accounts/' + $scope.accountSlug() + '/roles/' + $scope.currentRole() + '/benefit_plans/' + benefitPlan.id + '.json', {
          is_enabled: !benefitPlan.is_enabled    
        })
        .success(function (data, status, headers, config) {
          $scope.benefitPlans[index] = data.benefit_plan;
        })
        .error(function (data, status, headers, config) {
          debugger
        });
    }

    $scope.deleteBenefitPlanAt = function (index) {
      var benefitPlan = $scope.benefitPlans[index];

      if (!benefitPlan) {
        debugger
      }

      $http
        .delete('/api/v1/accounts/' + $scope.accountSlug() + '/roles/' + $scope.currentRole() + '/benefit_plans/' + benefitPlan.id + '.json')
        .success(function (data, status, headers, config) {
          $scope.benefitPlans.splice(index, 1);
        })
        .error(function (data, status, headers, config) {
          debugger
        });
    };

    $http
      .get('/api/v1/accounts/' + $scope.accountSlug() + '/roles/' + $scope.currentRole() + '/benefit_plans.json')
      .success(function (data, status, headers, config) {
        $scope.benefitPlans = data.benefit_plans;

        $scope.ready();
      })
      .error(function (data, status, headers, config) {
        debugger
      });
  }
]);

congoApp.controller('BenefitPlansNewController', [
  '$scope', '$http', '$location', 'propertiesFactory',
  function ($scope, $http, $location) {
    // Make sure user is totally signed up before continuing.
    $scope.enforceValidAccount();

    $scope.elements = [];
    $scope.carrierAccounts = null;
    $scope.selectedCarrierAccount = null;

    $scope.submit = function () {
      var properties = propertiesFactory.getPropertiesFromElements($scope.elements);

      $http
        .post('/api/v1/accounts/' + $scope.accountSlug() + '/roles/' + $scope.currentRole() + '/benefit_plans.json', {
          name: $scope.name,
          carrier_account_id: $scope.selectedCarrierAccount.id,
          properties: properties
        })
        .success(function (data, status, headers, config) {
          $location.path('/accounts/' + $scope.accountSlug() + '/' + $scope.currentRole() + '/benefit_plans');
        })
        .error(function (data, status, headers, config) {
          debugger
        });
    };

    function done () {
      if ($scope.elements && $scope.carrierAccounts) {
        $scope.ready();
      }
    }

    $http
      .get('/api/v1/accounts/' + $scope.accountSlug() + '/roles/' + $scope.currentRole() + '/properties/accounts.json')
      .success(function (data, status, headers, config) {
        $scope.elements = data.elements;

        done();
      })
      .error(function (data, status, headers, config) {
        debugger
      });

    $http
      .get('/api/v1/accounts/' + $scope.accountSlug() + '/roles/' + $scope.currentRole() + '/carrier_accounts.json')
      .success(function (data, status, headers, config) {
        $scope.carrierAccounts = data.carrier_accounts;
        $scope.selectedCarrierAccount = data.carrier_accounts[0];

        done();
      })
      .error(function (data, status, headers, config) {
        debugger
      });
  }
]);

congoApp.controller('BenefitPlansShowController', [
  '$scope', '$http', '$location',
  function ($scope, $http, $location) {
    // Make sure user is totally signed up before continuing.
    $scope.enforceValidAccount();

    $scope.benefitPlan = null;

    $http
      .get('/api/v1/accounts/' + $scope.accountSlug() + '/roles/' + $scope.currentRole() + '/benefit_plans/' + $scope.benefitPlanId() + '.json', {
        name: $scope.name
      })
      .success(function (data, status, headers, config) {
        $scope.benefitPlan = data.benefit_plan;

        $scope.ready();
      })
      .error(function (data, status, headers, config) {
        debugger
      });
  }
]);

congoApp.controller('GroupsIndexController', [
  '$scope', '$http', '$location',
  function ($scope, $http, $location) {
    // Make sure user is totally signed up before continuing.
    $scope.enforceValidAccount();

    $scope.toggleGroupAt = function (index) {
      var group = $scope.groups[index];

      if (!group) {
        debugger
      }

      console.log(group.is_enabled);

      $http
        .put('/api/v1/accounts/' + $scope.accountSlug() + '/roles/' + $scope.currentRole() + '/groups/' + group.id + '.json', {
          is_enabled: !group.is_enabled    
        })
        .success(function (data, status, headers, config) {
          $scope.groups[index] = data.group;
        })
        .error(function (data, status, headers, config) {
          debugger
        });
    }

    $scope.deleteGroupAt = function (index) {
      var group = $scope.groups[index];

      if (!group) {
        debugger
      }

      $http
        .delete('/api/v1/accounts/' + $scope.accountSlug() + '/roles/' + $scope.currentRole() + '/groups/' + group.id + '.json')
        .success(function (data, status, headers, config) {
          $scope.groups.splice(index, 1);
        })
        .error(function (data, status, headers, config) {
          debugger
        });
    };

    $http
      .get('/api/v1/accounts/' + $scope.accountSlug() + '/roles/' + $scope.currentRole() + '/groups.json')
      .success(function (data, status, headers, config) {
        $scope.groups = data.groups;

        $scope.ready();
      })
      .error(function (data, status, headers, config) {
        debugger
      });
  }
]);

congoApp.controller('GroupsNewController', [
  '$scope', '$http', '$location', 'propertiesFactory',
  function ($scope, $http, $location, propertiesFactory) {
    // Make sure user is totally signed up before continuing.
    $scope.enforceValidAccount();

    $scope.elements = [];

    $scope.submit = function () {
      var properties = propertiesFactory.getPropertiesFromElements($scope.elements);

      $http
        .post('/api/v1/accounts/' + $scope.accountSlug() + '/roles/' + $scope.currentRole() + '/groups.json', {
          name: $scope.name,
          properties: properties
        })
        .success(function (data, status, headers, config) {
          $location.path('/accounts/' + $scope.accountSlug() + '/' + $scope.currentRole() + '/groups');

          $scope.ready();
        })
        .error(function (data, status, headers, config) {
          debugger
        });
    };

    $http
      .get('/api/v1/accounts/' + $scope.accountSlug() + '/roles/' + $scope.currentRole() + '/properties/groups.json')
      .success(function (data, status, headers, config) {
        $scope.elements = data.elements;

        $scope.ready();
      })
      .error(function (data, status, headers, config) {
        debugger
      });
  }
]);

congoApp.controller('GroupsShowController', [
  '$scope', '$http', '$location', '$cookieStore',
  function ($scope, $http, $location, $cookieStore) {
    // Make sure user is totally signed up before continuing.
    $scope.enforceValidAccount();

    $scope.formData = {
      email: null 
    };

    // Only used by group admins
    $scope.memberships = function () {
      if ($scope.group) {
        return $scope.group.memberships;
      }
    };

    // Only used by customers
    $scope.applications = function (benefitPlan) {
      if ($scope.group) {
        return _($scope.group.applications).where({ benefit_plan_id: benefitPlan.id });
      }
    };

    $scope.selectBenefitPlan = function (benefitPlan) {
      if (!benefitPlan) {
        debugger
      }

      var data = {
        group_slug: $scope.groupSlug(),
        benefit_plan_id: benefitPlan.id
      };

      $http
        .post('/api/v1/accounts/' + $scope.accountSlug() + '/roles/' + $scope.currentRole() + '/applications.json', data)
        .success(function (data, status, headers, config) {
          $cookieStore.put('current-application-id', data.application.id);

          $location.path('/accounts/' + $scope.accountSlug() + '/' + $scope.currentRole() + '/groups/' + $scope.groupSlug() + '/benefit_plans/' + benefitPlan.id + '/applications/new');
        })
        .error(function (data, status, headers, config) {
          debugger
        });
    };

    $scope.declineBenefitPlan = function (benefitPlan) {
      if (!benefitPlan) {
        debugger
      }

      var data = {
        group_slug: $scope.groupSlug(),
        benefit_plan_id: benefitPlan.id,
        declined_by_id: congo.currentUser.id
      };

      $http
        .post('/api/v1/accounts/' + $scope.accountSlug() + '/roles/' + $scope.currentRole() + '/applications.json', data)
        .success(function (data, status, headers, config) {
          $scope.group.applications.push(data.application);

          $location.path('/accounts/' + $scope.accountSlug() + '/' + $scope.currentRole() + '/groups/' + $scope.groupSlug());
        })
        .error(function (data, status, headers, config) {
          debugger
        });
    };

    $scope.inviteMember = function () {
      var email = $scope.formData.email;
      var data = {
        email: email
      };

      $http
        .post('/api/v1/accounts/' + $scope.accountSlug() + '/roles/' + $scope.currentRole() + '/groups/' + $scope.groupSlug() + '/memberships.json', data)
        .success(function (data, status, headers, config) {
          $scope.formData.email = '';
          $scope.group.memberships.push(data.membership);    
        })
        .error(function (data, status, headers, config) {
          debugger
        });
    };

    $scope.resendConfirmation = function (membership) {
      $http
        .post('/api/v1/accounts/' + $scope.accountSlug() + '/roles/' + $scope.currentRole() + '/groups/' + $scope.groupSlug() + '/memberships/' + membership.id + '/confirmations.json')
        .success(function (data, status, headers, config) {
          debugger
        })
        .error(function (data, status, headers, config) {
          debugger
        });
    };

    $scope.revokeMembership = function (membership) {
      $http
        .delete('/api/v1/accounts/' + $scope.accountSlug() + '/roles/' + $scope.currentRole() + '/groups/' + $scope.groupSlug() + '/memberships/' + membership.id + '.json')
        .success(function (data, status, headers, config) {
          $scope.group.memberships = _($scope.group.memberships).reject(function (m) {
            return membership.id === m.id;
          });
        })
        .error(function (data, status, headers, config) {
          debugger
        });
    };

    $scope.submitApplication = function (application) {
      var data = {
        applied_by_id: $scope.userId()
      }

      $http
        .put('/api/v1/accounts/' + $scope.accountSlug() + '/roles/' + $scope.currentRole() + '/applications/' + application.id + '.json', data)
        .success(function (data, status, headers, config) {
          debugger
        })
        .error(function (data, status, headers, config) {
          debugger
        });
    };

    $scope.enableBenefitPlan = function (benefitPlan) {
      var data = {
        benefit_plan_id: benefitPlan.id
      }

      $http
        .post('/api/v1/accounts/' + $scope.accountSlug() + '/roles/' + $scope.currentRole() + '/groups/' + $scope.groupSlug() + '/group_benefit_plans.json', data)
        .success(function (data, status, headers, config) {
          benefitPlan.isEnabled = true;
        })
        .error(function (data, status, headers, config) {
          debugger
        });
    };

    $scope.changeBenefitPlan = function (benefitPlan) {
      if (benefitPlan.isEnabled) {
        var data = {
          benefit_plan_id: benefitPlan.id
        }

        $http
          .post('/api/v1/accounts/' + $scope.accountSlug() + '/roles/' + $scope.currentRole() + '/groups/' + $scope.groupSlug() + '/group_benefit_plans.json', data)
          .success(function (data, status, headers, config) {
            benefitPlan.isEnabled = true;
          })
          .error(function (data, status, headers, config) {
            debugger
          });
      } else {
        $http
          .delete('/api/v1/accounts/' + $scope.accountSlug() + '/roles/' + $scope.currentRole() + '/groups/' + $scope.groupSlug() + '/group_benefit_plans.json?benefit_plan_id=' + benefitPlan.id)
          .success(function (data, status, headers, config) {
            benefitPlan.isEnabled = false;
          })
          .error(function (data, status, headers, config) {
            debugger
          });
      }
    };

    function done() {
      if ($scope.benefitPlans && $scope.group) {
        _($scope.benefitPlans).each(function (benefitPlan) {
          benefitPlan.isEnabled = !!_($scope.group.benefitPlans).findWhere({ id: benefitPlan.id });

          $scope.ready();
        });
      }
    }

    $http
      .get('/api/v1/accounts/' + $scope.accountSlug() + '/roles/' + $scope.currentRole() + '/benefit_plans.json')
      .success(function (data, status, headers, config) {
        $scope.benefitPlans = data.benefit_plans;
        done();
      })
      .error(function (data, status, headers, config) {
        debugger
      });

    $http
      .get('/api/v1/accounts/' + $scope.accountSlug() + '/roles/' + $scope.currentRole() + '/groups/' + $scope.groupSlug() + '.json')
      .success(function (data, status, headers, config) {
        $scope.group = data.group;
        done();
      })
      .error(function (data, status, headers, config) {
        debugger
      });
  }
]);

congoApp.controller('ApplicationsNewController', [
  '$scope', '$http', '$location', '$cookieStore',
  function ($scope, $http, $location, $cookieStore) {
    // Make sure user is totally signed up before continuing.
    $scope.enforceValidAccount();

    $scope.group = null;
    $scope.benefitPlan = null;

    $scope.submit = function () {
      var properties = _.reduce(
        $('#enrollment-form form').serializeArray(),
        function (sum, element) {
          sum[element.name] = element.value;
          return sum;
        },
        {}
      );

      var data = {
        group_slug: $scope.groupSlug(),
        benefit_plan_id: $scope.benefitPlanId(),
        properties: properties
      };

      var id = $cookieStore.get('current-application-id');

      $http
        .put('/api/v1/accounts/' + $scope.accountSlug() + '/roles/' + $scope.currentRole() + '/applications/' + id  + '.json', data)
        .success(function (data, status, headers, config) {
          $cookieStore.remove('current-application-id');

          $location.path('/accounts/' + $scope.accountSlug() + '/' + $scope.currentRole());
        })
        .error(function (data, status, headers, config) {
          debugger
        });
    }

    function done () {
      if ($scope.group && $scope.benefitPlan) {
        $scope.ready();
      }
    }

    $http
      .get('/api/v1/accounts/' + $scope.accountSlug() + '/roles/' + $scope.currentRole() + '/groups/' + $scope.groupSlug() + '.json')
      .success(function (data, status, headers, config) {
        $scope.group = data.group;

        done();
      })
      .error(function (data, status, headers, config) {
        debugger
      });

    $http
      .get('/api/v1/accounts/' + $scope.accountSlug() + '/roles/' + $scope.currentRole() + '/benefit_plans/' + $scope.benefitPlanId() + '.json')
      .success(function (data, status, headers, config) {
        $scope.benefitPlan = data.benefit_plan;

        done();
      })
      .error(function (data, status, headers, config) {
        debugger
      });
  }
]);

congoApp.controller('ApplicationsShowController', [
  '$scope', '$http', '$location',
  function ($scope, $http, $location) {
    // Make sure user is totally signed up before continuing.
    $scope.enforceValidAccount();

    $http
      .get('/api/v1/accounts/' + $scope.accountSlug() + '/roles/' + $scope.currentRole() + '/applications/' + $scope.applicationId() + '.json')
      .success(function (data, status, headers, config) {
        $scope.applications = data.applications;

        $scope.ready();
      })
      .error(function (data, status, headers, config) {
        debugger
      });
  }
]);

congoApp.controller('ApplicationsIndexController', [
  '$scope', '$http', '$location',
  function ($scope, $http, $location) {
    // Make sure user is totally signed up before continuing.
    $scope.enforceValidAccount();

    $http
      .get('/api/v1/accounts/' + $scope.accountSlug() + '/roles/' + $scope.currentRole() + '/applications.json')
      .success(function (data, status, headers, config) {
        $scope.applications = data.applications;

        $scope.ready();
      })
      .error(function (data, status, headers, config) {
        debugger
      });
  }
]);

