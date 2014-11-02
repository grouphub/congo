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

  $scope.hasRole = function (name) {
    return userDataFactory.hasRole(name);
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

congoApp.controller('HomeController', function ($scope, userDataFactory) {
  $scope.hasRole = function (name) {
    return userDataFactory.hasRole(name);
  };

  $scope.firstName = function () {
    return userDataFactory.firstName();
  };

  $scope.accountName = function () {
    return userDataFactory.accountName();
  };
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

congoApp.controller('UsersShowController', function ($scope, $http, $location, userDataFactory) {
  $scope.user = null;

  $scope.userId = function () {
    return userDataFactory.userId();
  }

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

congoApp.controller('CarriersIndexController', function ($scope, $http, $location, userDataFactory) {
  $scope.isAdmin = function () {
    return userDataFactory.isAdmin();
  };

  $http
    .get('/api/v1/carriers.json')
    .success(function (data, status, headers, config) {
      $scope.carriers = data.carriers;
    })
    .error(function (data, status, headers, config) {
      debugger
    });
});

congoApp.controller('CarriersNewController', function ($scope, $http, $location, userDataFactory) {
  $scope.isAdmin = function () {
    return userDataFactory.isAdmin();
  };

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

congoApp.controller('CarriersShowController', function ($scope, $http, $location, userDataFactory) {
  $scope.isAdmin = function () {
    return userDataFactory.isAdmin();
  };

  $scope.carrierSlug = function () {
    return userDataFactory.carrierSlug();
  };

  $http
    .get('/api/v1/carriers/' + $scope.carrierSlug() + '.json')
    .success(function (data, status, headers, config) {
      $scope.carrier = data.carrier;
    })
    .error(function (data, status, headers, config) {
      debugger
    });
});

congoApp.controller('ProductsIndexController', function ($scope, $http, $location, userDataFactory) {
  $scope.accountSlug = function () {
    return userDataFactory.accountSlug();
  };

  $scope.currentRole = function () {
    return userDataFactory.currentRole();
  };

  $http
    .get('/api/v1/accounts/' + $scope.accountSlug() + '/products.json')
    .success(function (data, status, headers, config) {
      $scope.products = data.products;
    })
    .error(function (data, status, headers, config) {
      debugger
    });

  $scope.deleteProductAt = function (index) {
    var product = $scope.products[index];

    if (!product) {
      debugger
    }

    $http
      .delete('/api/v1/accounts/' + $scope.accountSlug() + '/products/' + product.id + '.json')
      .success(function (data, status, headers, config) {
        $scope.products.splice(index, 1);
      })
      .error(function (data, status, headers, config) {
        debugger
      });
    };
});

congoApp.controller('ProductsNewController', function ($scope, $http, $location, userDataFactory) {
  $scope.accountSlug = function () {
    return userDataFactory.accountSlug();
  };

  $scope.currentRole = function () {
    return userDataFactory.currentRole();
  };

  $scope.elements = [];
  $scope.carriers = [];
  $scope.selectedCarrier = null;

  $http
    .get('/assets/products-new-properties.json')
    .success(function (data, status, headers, config) {
      $scope.elements = data;
    })
    .error(function (data, status, headers, config) {
      debugger
    });

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
      .post('/api/v1/accounts/' + $scope.accountSlug() + '/products.json', {
        name: $scope.name,
        carrier_slug: $scope.selectedCarrier
      })
      .success(function (data, status, headers, config) {
        $location.path('/accounts/' + $scope.accountSlug() + '/' + $scope.currentRole() + '/products');
      })
      .error(function (data, status, headers, config) {
        debugger
      });
  };
});

congoApp.controller('ProductsShowController', function ($scope, $http, $location, userDataFactory) {
  $scope.accountSlug = function () {
    return userDataFactory.accountSlug();
  };

  $scope.currentRole = function () {
    return userDataFactory.currentRole();
  };

  $scope.productId = function () {
    return userDataFactory.productId();
  };

  $scope.product = undefined;

  $http
    .get('/api/v1/accounts/' + $scope.accountSlug() + '/products/' + $scope.productId() + '.json', {
      name: $scope.name
    })
    .success(function (data, status, headers, config) {
      $scope.product = data.product;
    })
    .error(function (data, status, headers, config) {
      debugger
    });
});

congoApp.controller('GroupsIndexController', function ($scope, $http, $location, userDataFactory) {
  $scope.accountSlug = function () {
    return userDataFactory.accountSlug();
  };

  $scope.currentRole = function () {
    return userDataFactory.currentRole();
  };

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

congoApp.controller('GroupsNewController', function ($scope, $http, $location, userDataFactory) {
  $scope.accountSlug = function () {
    return userDataFactory.accountSlug();
  };

  $scope.currentRole = function () {
    return userDataFactory.currentRole();
  };

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

congoApp.controller('GroupsShowController', function ($scope, $http, $location, userDataFactory) {
  $scope.accountSlug = function () {
    return userDataFactory.accountSlug();
  };

  $scope.groupSlug = function () {
    return userDataFactory.groupSlug();
  };

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

  $scope.enableProduct = function (product) {
    var data = {
      product_id: product.id
    }

    $http
      .post('/api/v1/accounts/' + $scope.accountSlug() + '/groups/' + $scope.groupSlug() + '/group_products.json', data)
      .success(function (data, status, headers, config) {
        product.isEnabled = true;
      })
      .error(function (data, status, headers, config) {
        debugger
      });
  };

  $scope.changeProduct = function (product) {
    if (product.isEnabled) {
      var data = {
        product_id: product.id
      }

      $http
        .post('/api/v1/accounts/' + $scope.accountSlug() + '/groups/' + $scope.groupSlug() + '/group_products.json', data)
        .success(function (data, status, headers, config) {
          product.isEnabled = true;
        })
        .error(function (data, status, headers, config) {
          debugger
        });
    } else {
      $http
        .delete('/api/v1/accounts/' + $scope.accountSlug() + '/groups/' + $scope.groupSlug() + '/group_products.json?product_id=' + product.id)
        .success(function (data, status, headers, config) {
          product.isEnabled = false;
        })
        .error(function (data, status, headers, config) {
          debugger
        });
    }
  };

  function done() {
    if ($scope.products && $scope.group) {
      _($scope.products).each(function (product) {
        product.isEnabled = !!_($scope.group.products).findWhere({ id: product.id });
      });
    }
  }

  $http
    .get('/api/v1/accounts/' + $scope.accountSlug() + '/products.json')
    .success(function (data, status, headers, config) {
      $scope.products = data.products;
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

congoApp.controller('ApplicationsNewController', function ($scope, $http, $location, userDataFactory) {
  $scope.group = null;
  $scope.product = null;

  $scope.accountSlug = function () {
    return userDataFactory.accountSlug();
  };

  $scope.groupSlug = function () {
    return userDataFactory.groupSlug();
  };

  $scope.productId = function () {
    return userDataFactory.productId();
  };

  $scope.currentRole = function () {
    return userDataFactory.currentRole();
  };

  $scope.submit = function () {
    var data = {
      group_slug: $scope.groupSlug(),
      product_id: $scope.productId()
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

  window.$scope = $scope;

  $http
    .get('/api/v1/accounts/' + $scope.accountSlug() + '/groups/' + $scope.groupSlug() + '.json')
    .success(function (data, status, headers, config) {
      $scope.group = data.group;
    })
    .error(function (data, status, headers, config) {
      debugger
    });

  $http
    .get('/api/v1/accounts/' + $scope.accountSlug() + '/products/' + $scope.productId() + '.json')
    .success(function (data, status, headers, config) {
      $scope.product = data.product;
    })
    .error(function (data, status, headers, config) {
      debugger
    });
});

congoApp.controller('ApplicationsIndexController', function ($scope, $http, $location, userDataFactory) {
  $scope.accountSlug = function () {
    return userDataFactory.accountSlug();
  };

  $http
    .get('/api/v1/accounts/' + $scope.accountSlug() + '/applications.json')
    .success(function (data, status, headers, config) {
      $scope.applications = data.applications;
    })
    .error(function (data, status, headers, config) {
      debugger
    });
});

