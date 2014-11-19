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
    $scope.vent.on($scope, 'flashes:added', function () {
      $scope.flashes = flashesFactory.flashes;
    });

    _(window.congo.flashes).each(function (flash) {
      flashesFactory.add(flash.type, flash.message);
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
        slug: 'first_account'
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
  '$scope', '$http', '$location',
  function ($scope, $http, $location) {
    $scope.elements = [];

    $scope.submit = function () {
      var properties = _.reduce(
        $scope.elements,
        function (sum, element) {
          sum[element.name] = element.value;
          return sum;
        },
        {}
      );

      var data = {
        account_id: congo.currentUser.accounts[0].id,
        account_name: $scope.name,
        account_tagline: $scope.tagline,
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
      .get('/assets/accounts-new-properties.json')
      .success(function (data, status, headers, config) {
        $scope.elements = data;

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
  '$scope', '$http', '$location',
  function ($scope, $http, $location) {
    $scope.elements = [];

    $scope.submit = function () {
      var properties = _.reduce(
        $scope.elements,
        function (sum, element) {
          sum[element.name] = element.value;
          return sum;
        },
        {}
      );

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
      .get('/assets/carriers-new-properties.json')
      .success(function (data, status, headers, config) {
        $scope.elements = data;

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

congoApp.controller('AccountCarriersIndexController', [
  '$scope', '$http', '$location',
  function ($scope, $http, $location) {
    // Make sure user is totally signed up before continuing.
    $scope.enforceValidAccount();

    $scope.accountCarriers = null;

    $scope.deleteAccountCarrierAt = function (index) {
      var accountCarrier = $scope.accountCarriers[index];

      if (!accountCarrier) {
        debugger
      }

      $http
        .delete('/api/v1/accounts/' + $scope.accountSlug() + '/roles/' + $scope.currentRole() + '/account_carriers/' + accountCarrier.id + '.json')
        .success(function (data, status, headers, config) {
          $scope.accountCarriers.splice(index, 1);
        })
        .error(function (data, status, headers, config) {
          debugger
        });
    };

    $http
      .get('/api/v1/accounts/' + $scope.accountSlug() + '/roles/' + $scope.currentRole() + '/account_carriers.json')
      .success(function (data, status, headers, config) {
        $scope.accountCarriers = data.account_carriers;

        $scope.ready();
      })
      .error(function (data, status, headers, config) {
        debugger
      });
  }
]);

congoApp.controller('AccountCarriersNewController', [
  '$scope', '$http', '$location',
  function ($scope, $http, $location) {
    // Make sure user is totally signed up before continuing.
    $scope.enforceValidAccount();

    $scope.elements = null;
    $scope.carriers = null;
    $scope.selectedCarrier = null;

    $scope.submit = function () {
      var properties = _.reduce(
        $scope.elements,
        function (sum, element) {
          sum[element.name] = element.value;
          return sum;
        },
        {}
      );

      $http
        .post('/api/v1/accounts/' + $scope.accountSlug() + '/roles/' + $scope.currentRole() + '/account_carriers.json', {
          name: $scope.name,
          carrier_slug: $scope.selectedCarrier.slug,
          properties: properties
        })
        .success(function (data, status, headers, config) {
          $location.path('/accounts/' + $scope.accountSlug() + '/' + $scope.currentRole() + '/account_carriers');
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
      .get('/assets/benefit-plans-new-properties.json')
      .success(function (data, status, headers, config) {
        $scope.elements = data;

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

congoApp.controller('AccountCarriersShowController', [
  '$scope', '$http', '$location',
  function ($scope, $http, $location) {
    // Make sure user is totally signed up before continuing.
    $scope.enforceValidAccount();

    $scope.accountCarrier = null;

    $http
      .get('/api/v1/accounts/' + $scope.accountSlug() + '/roles/' + $scope.currentRole() + '/account_carriers/' + $scope.accountCarrierId() + '.json')
      .success(function (data, status, headers, config) {
        $scope.accountCarrier = data.account_carrier;

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

    $scope.deleteBenefitPlanAt = function (index) {
      var benefitPlan = $scope.benefitPlans[index];

      if (!benefitPlan) {
        debugger
      }

      $http
        .delete('/api/v1/accounts/' + $scope.accountSlug() + '/roles/' + $scope.currentRole() + '/benefit_plan/' + benefitPlan.id + '.json')
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
  '$scope', '$http', '$location',
  function ($scope, $http, $location) {
    // Make sure user is totally signed up before continuing.
    $scope.enforceValidAccount();

    $scope.elements = null;
    $scope.accountCarriers = null;
    $scope.selectedAccountCarrier = null;

    $scope.submit = function () {
      var properties = _.reduce(
        $scope.elements,
        function (sum, element) {
          sum[element.name] = element.value;
          return sum;
        },
        {}
      );

      $http
        .post('/api/v1/accounts/' + $scope.accountSlug() + '/roles/' + $scope.currentRole() + '/benefit_plans.json', {
          name: $scope.name,
          account_carrier_id: $scope.selectedAccountCarrier.id,
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
      if ($scope.elements && $scope.accountCarriers) {
        $scope.ready();
      }
    }

    $http
      .get('/assets/benefit-plans-new-properties.json')
      .success(function (data, status, headers, config) {
        $scope.elements = data;

        done();
      })
      .error(function (data, status, headers, config) {
        debugger
      });

    $http
      .get('/api/v1/accounts/' + $scope.accountSlug() + '/roles/' + $scope.currentRole() + '/account_carriers.json')
      .success(function (data, status, headers, config) {
        $scope.accountCarriers = data.account_carriers;
        $scope.selectedAccountCarrier = data.account_carriers[0];

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
  '$scope', '$http', '$location',
  function ($scope, $http, $location) {
    // Make sure user is totally signed up before continuing.
    $scope.enforceValidAccount();

    $scope.elements = [];

    $scope.submit = function () {
      var properties = _.reduce(
        $scope.elements,
        function (sum, element) {
          sum[element.name] = element.value;
          return sum;
        },
        {}
      );

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
      .get(congo.assets['groups-new-properties.json'])
      .success(function (data, status, headers, config) {
        $scope.elements = data;

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
        submitted_by_id: $scope.userId()
      }

      $http
        .put('/api/v1/accounts/' + $scope.accountSlug() + '/roles/' + $scope.currentRole() + '/applications/' + application.id + '.json', data)
        .success(function (data, status, headers, config) {
          application.submitted_by_id = congo.currentUser.id
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

    $scope.disableBenefitPlan = function (benefitPlan) {
      var data = {
        benefit_plan_id: benefitPlan.id
      }

      $http
        .post('/api/v1/accounts/' + $scope.accountSlug() + '/roles/' + $scope.currentRole() + '/groups/' + $scope.groupSlug() + '/group_benefit_plans.json', data)
        .success(function (data, status, headers, config) {
          benefitPlan.isEnabled = false;
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

    $scope.elements = [];
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
      if ($scope.elements && $scope.group && $scope.benefitPlan) {
        $scope.ready();
      }
    }

    $http
      .get('/assets/applications-new-properties.json')
      .success(function (data, status, headers, config) {
        $scope.elements = data;

        $scope.ready();
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

