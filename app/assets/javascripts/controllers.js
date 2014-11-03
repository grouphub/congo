var congoApp = angular.module('congoApp', ['ngRoute', 'ngCookies']);

congoApp.controller('MainController', function ($scope, $http, $location, userDataFactory, flashesFactory, eventsFactory) {
  $scope.flashes = flashesFactory.flashes;
  eventsFactory.on($scope, 'flash_added', function () {
    $scope.flashes = flashesFactory.flashes;
  });

  $scope.isAdmin = function () {
    return userDataFactory.isAdmin();
  };

  $scope.inAdminPanel = function () {
    return userDataFactory.inAdminPanel();
  };

  $scope.accountName = function () {
    return userDataFactory.accountName();
  };

  $scope.isSignedin = function () {
    return userDataFactory.isSignedin();
  };

  $scope.firstName = function () {
    return userDataFactory.firstName();
  };

  $scope.accounts = function () {
    return userDataFactory.accounts();
  };

  $scope.accountSlug = function () {
    return userDataFactory.accountSlug();
  };

  $scope.currentRole = function () {
    return userDataFactory.currentRole();
  };

  $scope.currentUserId = function () {
    return userDataFactory.currentUserId();
  };

  $scope.isDrawerShown = function () {
    return userDataFactory.isDrawerShown();
  }

  $scope.drawerToggle = function () {
    userDataFactory.drawerToggle();
  };

  $scope.flashes = function () {
    return flashesFactory.all();
  };

  $scope.carrierSlug = function () {
    return userDataFactory.carrierSlug();
  };

  $scope.groupSlug = function () {
    return userDataFactory.groupSlug();
  };

  $scope.accountCarrierId = function () {
    return userDataFactory.accountCarrierId();
  };

  $scope.benefitPlanId = function () {
    return userDataFactory.benefitPlanId();
  };

  $scope.$watch('flashes');

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
});

congoApp.controller('LandingController', function ($scope) {

});

congoApp.controller('HomeController', function ($scope) {

});

congoApp.controller('UsersSigninController', function ($scope, $http, $location, flashesFactory) {
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
});

congoApp.controller('UsersNewManagerController', function ($scope, $http, $location, flashesFactory) {
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
});

congoApp.controller('UsersNewPlanController', function ($scope, $http, $location, flashesFactory) {
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
});

congoApp.controller('UsersNewBillingController', function ($scope, $http, $location) {
  $scope.submit = function () {
    $http
      .put('/api/v1/users/' + congo.currentUser.id + '.json', {
        card_number: $scope.cardNumber,
        month: $scope.month,
        year: $scope.year,
        cvc: $scope.cvc
      })
      .success(function (data, status, headers, config) {
        $location.path('/users/new_account');
      })
      .error(function (data, status, headers, config) {
        flashesFactory.add('danger', 'There was a problem setting up your payment info.');
      });
  };
});

congoApp.controller('UsersNewAccountController', function ($scope, $http, $location) {
  $scope.submit = function () {
    $http
      .put('/api/v1/users/' + congo.currentUser.id + '.json', {
        account_id: congo.currentUser.accounts[0].id,
        account_name: $scope.name,
        account_tagline: $scope.tagline
      })
      .success(function (data, status, headers, config) {
        var account;

        congo.currentUser = data.user;

        account = congo.currentUser.accounts[0];

        $location.path('/accounts/' + account.slug + '/' + account.role);

        flashesFactory.add('success', 'Welcome, ' + congo.currentUser.first_name + ' ' + congo.currentUser.last_name + '!');
      })
      .error(function (data, status, headers, config) {
        flashesFactory.add('danger', 'There was a problem creating your account.');
      });
  };
});

congoApp.controller('UsersNewCustomerController', function ($scope, $http, $location) {
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
});

congoApp.controller('UsersShowController', function ($scope, $http, $location) {
  $scope.user = null;

  $scope.$watch('user');

  $http
    .get('/api/v1/users/' + $scope.userId() + '.json')
    .success(function (data, status, headers, config) {
      $scope.user = data.user;
    })
    .error(function (data, status, headers, config) {
      debugger
    });
});

congoApp.controller('CarriersNewController', function ($scope, $http, $location) {
  $scope.submit = function () {
    // TODO: Get properties out of `elements` (stored in `value`)

    $http
      .post('/api/v1/carriers.json', {
        name: $scope.name
      })
      .success(function (data, status, headers, config) {
        $location.path('/admin/carriers');
      })
      .error(function (data, status, headers, config) {
        debugger
      });
  };
});

congoApp.controller('CarriersIndexController', function ($scope, $http, $location) {
  $http
    .get('/api/v1/carriers.json')
    .success(function (data, status, headers, config) {
      $scope.carriers = data.carriers;
    })
    .error(function (data, status, headers, config) {
      debugger
    });
});

congoApp.controller('CarriersShowController', function ($scope, $http, $location) {
  $http
    .get('/api/v1/carriers/' + $scope.carrierSlug() + '.json')
    .success(function (data, status, headers, config) {
      $scope.carrier = data.carrier;
    })
    .error(function (data, status, headers, config) {
      debugger
    });
});

congoApp.controller('AccountCarriersIndexController', function ($scope, $http, $location) {
  $scope.accountCarriers = null;

  $http
    .get('/api/v1/accounts/' + $scope.accountSlug() + '/account_carriers.json')
    .success(function (data, status, headers, config) {
      $scope.accountCarriers = data.account_carriers;
    })
    .error(function (data, status, headers, config) {
      debugger
    });

  $scope.deleteAccountCarrierAt = function (index) {
    var accountCarrier = $scope.accountCarriers[index];

    if (!accountCarrier) {
      debugger
    }

    $http
      .delete('/api/v1/accounts/' + $scope.accountSlug() + '/account_carriers/' + accountCarrier.id + '.json')
      .success(function (data, status, headers, config) {
        $scope.accountCarriers.splice(index, 1);
      })
      .error(function (data, status, headers, config) {
        debugger
      });
  };
});

congoApp.controller('AccountCarriersNewController', function ($scope, $http, $location) {
  $scope.carriers = null;
  $scope.selectedCarrier = null;

  $http
    .get('/api/v1/carriers.json')
    .success(function (data, status, headers, config) {
      $scope.carriers = data.carriers;
      $scope.selectedCarrier = data.carriers[0];
    })
    .error(function (data, status, headers, config) {
      debugger
    });

  $scope.submit = function () {
    // TODO: Get properties out of `elements` (stored in `value`)

    $http
      .post('/api/v1/accounts/' + $scope.accountSlug() + '/account_carriers.json', {
        name: $scope.name,
        carrier_slug: $scope.selectedCarrier.slug
      })
      .success(function (data, status, headers, config) {
        $location.path('/accounts/' + $scope.accountSlug() + '/' + $scope.currentRole() + '/account_carriers');
      })
      .error(function (data, status, headers, config) {
        debugger
      });
  };
});

congoApp.controller('AccountCarriersShowController', function ($scope, $http, $location) {
  $scope.accountCarrier = null;

  $http
    .get('/api/v1/accounts/' + $scope.accountSlug() + '/account_carriers/' + $scope.accountCarrierId() + '.json')
    .success(function (data, status, headers, config) {
      $scope.accountCarrier = data.account_carrier;
    })
    .error(function (data, status, headers, config) {
      debugger
    });
});

congoApp.controller('BenefitPlansIndexController', function ($scope, $http, $location) {
  $http
    .get('/api/v1/accounts/' + $scope.accountSlug() + '/benefit_plans.json')
    .success(function (data, status, headers, config) {
      $scope.benefitPlans = data.benefit_plans;
    })
    .error(function (data, status, headers, config) {
      debugger
    });

  $scope.deleteBenefitPlanAt = function (index) {
    var benefitPlan = $scope.benefitPlans[index];

    if (!benefitPlan) {
      debugger
    }

    $http
      .delete('/api/v1/accounts/' + $scope.accountSlug() + '/benefit_plan/' + benefitPlan.id + '.json')
      .success(function (data, status, headers, config) {
        $scope.benefitPlans.splice(index, 1);
      })
      .error(function (data, status, headers, config) {
        debugger
      });
  };
});

congoApp.controller('BenefitPlansNewController', function ($scope, $http, $location) {
  $scope.elements = [];
  $scope.accountCarriers = [];
  $scope.selectedAccountCarrier = null;

  $http
    .get('/assets/benefit-plans-new-properties.json')
    .success(function (data, status, headers, config) {
      $scope.elements = data;
    })
    .error(function (data, status, headers, config) {
      debugger
    });

  $http
    .get('/api/v1/accounts/' + $scope.accountSlug() + '/account_carriers.json')
    .success(function (data, status, headers, config) {
      $scope.accountCarriers = data.account_carriers;
      $scope.selectedAccountCarrier = data.account_carriers[0];
    })
    .error(function (data, status, headers, config) {
      debugger
    });

  $scope.submit = function () {
    // TODO: Get properties out of `elements` (stored in `value`)
    $http
      .post('/api/v1/accounts/' + $scope.accountSlug() + '/benefit_plans.json', {
        name: $scope.name,
        account_carrier_id: $scope.selectedAccountCarrier.id
      })
      .success(function (data, status, headers, config) {
        $location.path('/accounts/' + $scope.accountSlug() + '/' + $scope.currentRole() + '/benefit_plans');
      })
      .error(function (data, status, headers, config) {
        debugger
      });
  };
});

congoApp.controller('BenefitPlansShowController', function ($scope, $http, $location) {
  $scope.benefitPlan = null;

  $http
    .get('/api/v1/accounts/' + $scope.accountSlug() + '/benefit_plans/' + $scope.benefitPlanId() + '.json', {
      name: $scope.name
    })
    .success(function (data, status, headers, config) {
      $scope.benefitPlan = data.benefit_plan;
    })
    .error(function (data, status, headers, config) {
      debugger
    });
});

congoApp.controller('GroupsIndexController', function ($scope, $http, $location) {
  $http
    .get('/api/v1/accounts/' + $scope.accountSlug() + '/groups.json')
    .success(function (data, status, headers, config) {
      $scope.groups = data.groups;
    })
    .error(function (data, status, headers, config) {
      debugger
    });

  $scope.deleteGroupAt = function (index) {
    var group = $scope.groups[index];

    if (!group) {
      debugger
    }

    $http
      .delete('/api/v1/accounts/' + $scope.accountSlug() + '/groups/' + group.id + '.json')
      .success(function (data, status, headers, config) {
        $scope.groups.splice(index, 1);
      })
      .error(function (data, status, headers, config) {
        debugger
      });
    };
});

congoApp.controller('GroupsNewController', function ($scope, $http, $location) {
  $scope.submit = function () {
    $http
      .post('/api/v1/accounts/' + $scope.accountSlug() + '/groups.json', {
        name: $scope.name
      })
      .success(function (data, status, headers, config) {
        $location.path('/accounts/' + $scope.accountSlug() + '/' + $scope.currentRole() + '/groups');
      })
      .error(function (data, status, headers, config) {
        debugger
      });
  };
});

congoApp.controller('GroupsShowController', function ($scope, $http, $location) {
  $scope.memberships = function () {
    if ($scope.group) {
      return $scope.group.memberships;
    }
  };

  $scope.inviteMember = function () {
    var email = $scope.email;
    var data = {
      email: email
    };

    $http
      .post('/api/v1/accounts/' + $scope.accountSlug() + '/groups/' + $scope.groupSlug() + '/memberships.json', data)
      .success(function (data, status, headers, config) {
        $scope.group.memberships.push(data.membership);    
      })
      .error(function (data, status, headers, config) {
        debugger
      });
  };

  $scope.resendConfirmation = function (membership) {
    $http
      .post('/api/v1/accounts/' + $scope.accountSlug() + '/groups/' + $scope.groupSlug() + '/memberships/' + membership.id + '/confirmations.json')
      .success(function (data, status, headers, config) {
        debugger
      })
      .error(function (data, status, headers, config) {
        debugger
      });
  };

  $scope.revokeMembership = function (membership) {
    $http
      .delete('/api/v1/accounts/' + $scope.accountSlug() + '/groups/' + $scope.groupSlug() + '/memberships/' + membership.id + '.json')
      .success(function (data, status, headers, config) {
        $scope.group.memberships = _($scope.group.memberships).reject(function (m) {
          return membership.id === m.id;
        });
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
      .post('/api/v1/accounts/' + $scope.accountSlug() + '/groups/' + $scope.groupSlug() + '/group_benefit_plans.json', data)
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
        .post('/api/v1/accounts/' + $scope.accountSlug() + '/groups/' + $scope.groupSlug() + '/group_benefit_plans.json', data)
        .success(function (data, status, headers, config) {
          benefitPlan.isEnabled = true;
        })
        .error(function (data, status, headers, config) {
          debugger
        });
    } else {
      $http
        .delete('/api/v1/accounts/' + $scope.accountSlug() + '/groups/' + $scope.groupSlug() + '/group_benefit_plans.json?benefit_plan_id=' + benefitPlan.id)
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
      });
    }
  }

  $http
    .get('/api/v1/accounts/' + $scope.accountSlug() + '/benefit_plans.json')
    .success(function (data, status, headers, config) {
      $scope.benefitPlans = data.benefit_plans;
      done();
    })
    .error(function (data, status, headers, config) {
      debugger
    });

  $http
    .get('/api/v1/accounts/' + $scope.accountSlug() + '/groups/' + $scope.groupSlug() + '.json')
    .success(function (data, status, headers, config) {
      $scope.group = data.group;
      done();
    })
    .error(function (data, status, headers, config) {
      debugger
    });
});

congoApp.controller('ApplicationsNewController', function ($scope, $http, $location) {
  $scope.group = null;
  $scope.benefitPlan = null;

  $scope.submit = function () {
    var data = {
      group_slug: $scope.groupSlug(),
      benefit_plan_id: $scope.benefitPlanId()
    };

    $http
      .post('/api/v1/accounts/' + $scope.accountSlug() + '/applications.json', data)
      .success(function (data, status, headers, config) {
        $location.path('/accounts/' + $scope.accountSlug() + '/' + $scope.currentRole());
      })
      .error(function (data, status, headers, config) {
        debugger
      });
  }

  $http
    .get('/api/v1/accounts/' + $scope.accountSlug() + '/groups/' + $scope.groupSlug() + '.json')
    .success(function (data, status, headers, config) {
      $scope.group = data.group;
    })
    .error(function (data, status, headers, config) {
      debugger
    });

  $http
    .get('/api/v1/accounts/' + $scope.accountSlug() + '/benefit_plans/' + $scope.benefitPlanId() + '.json')
    .success(function (data, status, headers, config) {
      $scope.benefitPlan = data.benefit_plan;
    })
    .error(function (data, status, headers, config) {
      debugger
    });
});

congoApp.controller('ApplicationsIndexController', function ($scope, $http, $location) {
  $http
    .get('/api/v1/accounts/' + $scope.accountSlug() + '/applications.json')
    .success(function (data, status, headers, config) {
      $scope.applications = data.applications;
    })
    .error(function (data, status, headers, config) {
      debugger
    });
});

