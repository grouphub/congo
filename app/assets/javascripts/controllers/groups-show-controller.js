var congoApp = angular.module('congoApp');

// TODO: Make sure we output the server error if provided, otherwise show the canned error message.
congoApp.controller('GroupsShowController', [
  '$scope', '$http', '$location', '$cookieStore', 'eventsFactory', 'flashesFactory',
  function ($scope, $http, $location, $cookieStore, eventsFactory, flashesFactory) {
    // Make sure user is totally signed up before continuing.
    $scope.enforceValidAccount();

    $scope.form = {
      name: null,
      group_id: null
    };

    $scope.submit = function () {
      $http
        .put('/api/internal/accounts/' + $scope.accountSlug() + '/roles/' + $scope.currentRole() + '/groups/' + $scope.groupSlug() + '.json', {
          name: $scope.form.name,
          properties: $scope.form
        })
        .success(function (data, status, headers, config) {
          $location
            .path('/accounts/' + $scope.accountSlug() + '/' + $scope.currentRole() + '/groups/' + data.group.slug)
            .replace();
        })
        .error(function (data, status, headers, config) {
          flashesFactory.add('danger', 'There was a problem saving your group.');
        });
    };

    $scope.inviteMemberFormData = {
      email: null
    };

    $scope.inviteGroupAdminFormData = {
      email: null
    };

    // Only used by group admins
    $scope.customerMemberships = function () {
      if ($scope.group) {
        return $scope.group.customer_memberships;
      }
    };

    // Only used by group admins and brokers
    $scope.groupAdminMemberships = function () {
      if ($scope.group) {
        return $scope.group.group_admin_memberships;
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
        benefit_plan_id: benefitPlan.id,
        selected_by_id: congo.currentUser.id
      };

      $http
        .post('/api/internal/accounts/' + $scope.accountSlug() + '/roles/' + $scope.currentRole() + '/applications.json', data)
        .success(function (data, status, headers, config) {
          $cookieStore.put('current-application-id', data.application.id);

          $location.path('/accounts/' + $scope.accountSlug() + '/' + $scope.currentRole() + '/groups/' + $scope.groupSlug() + '/benefit_plans/' + benefitPlan.id + '/applications/new');
        })
        .error(function (data, status, headers, config) {
          flashesFactory.add('danger', 'There was a problem creating your application.');
        });
    };

    $scope.declineBenefitPlan = function (benefitPlan) {
      if (!benefitPlan) {
        flashesFactory.add('danger', 'We could not find a matching benefit plan.');
      }

      var data = {
        group_slug: $scope.groupSlug(),
        benefit_plan_id: benefitPlan.id,
        declined_by_id: congo.currentUser.id
      };

      $http
        .post('/api/internal/accounts/' + $scope.accountSlug() + '/roles/' + $scope.currentRole() + '/applications.json', data)
        .success(function (data, status, headers, config) {
          $scope.group.applications.push(data.application);

          $location.path('/accounts/' + $scope.accountSlug() + '/' + $scope.currentRole() + '/groups/' + $scope.groupSlug());
        })
        .error(function (data, status, headers, config) {
          flashesFactory.add('danger', 'There was a problem declining your application.');
        });
    };

    $scope.revokeApplication = function (application) {
      if (!application) {
        flashesFactory.add('danger', 'We could not find a matching application.');
      }

      $http
        .delete('/api/internal/accounts/' + $scope.accountSlug() + '/roles/' + $scope.currentRole() + '/applications/' + application.id + '.json')
        .success(function (data, status, headers, config) {
          $scope.group.applications = _($scope.group.applications).reject(function (groupApplication) {
            return application.id === groupApplication.id;
          });
        })
        .error(function (data, status, headers, config) {
          flashesFactory.add('danger', 'There was a problem deleting your application.');
        });
    };

    $scope.inviteMember = function () {
      var email = $scope.inviteMemberFormData.email;
      var data = {
        role_name: 'customer',
        email: email
      };
      $http
        .post('/api/internal/accounts/' + $scope.accountSlug() + '/roles/' + $scope.currentRole() + '/groups/' + $scope.groupSlug() + '/memberships.json', data)
        .success(function (data, status, headers, config) {
          $scope.inviteMemberFormData.email = '';
          $scope.group.memberships.push(data.membership);
          $scope.group.customer_memberships.push(data.membership);
        })
        .error(function (data, status, headers, config) {
          flashesFactory.add('danger', 'There was a problem inviting a new member.');
        });
    };

    $scope.inviteGroupAdmin = function () {
      var email = $scope.inviteGroupAdminFormData.email;
      var data = {
        role_name: 'group_admin',
        email: email
      };

      $http
        .post('/api/internal/accounts/' + $scope.accountSlug() + '/roles/' + $scope.currentRole() + '/groups/' + $scope.groupSlug() + '/memberships.json', data)
        .success(function (data, status, headers, config) {
          $scope.inviteGroupAdminFormData.email = '';
          $scope.group.memberships.push(data.membership);
          $scope.group.group_admin_memberships.push(data.membership);
        })
        .error(function (data, status, headers, config) {
          flashesFactory.add('danger', 'There was a problem inviting a new group admin.');
        });
    };

    $scope.sendConfirmation = function (membership) {
      $http
        .post('/api/internal/accounts/' + $scope.accountSlug() + '/roles/' + $scope.currentRole() + '/groups/' + $scope.groupSlug() + '/memberships/' + membership.id + '/confirmations.json')
        .success(function (data, status, headers, config) {
          // TODO: Do something...
        })
        .error(function (data, status, headers, config) {
          flashesFactory.add('danger', 'There was a problem sending a confirmation.');
        });
    };

    $scope.sendConfirmations = function () {
      $http
        .post('/api/internal/accounts/' + $scope.accountSlug() + '/roles/' + $scope.currentRole() + '/groups/' + $scope.groupSlug() + '/confirmations_all.json')
        .success(function (data, status, headers, config) {
          // TODO: Do something...
        })
        .error(function (data, status, headers, config) {
          flashesFactory.add('danger', 'There was a problem sending the confirmations.');
        });
    };

    $scope.revokeMembership = function (membership) {
      $http
        .delete('/api/internal/accounts/' + $scope.accountSlug() + '/roles/' + $scope.currentRole() + '/groups/' + $scope.groupSlug() + '/memberships/' + membership.id + '.json')
        .success(function (data, status, headers, config) {
          $scope.group.memberships = _($scope.group.memberships).reject(function (m) {
            return membership.id === m.id;
          });

          $scope.group.customer_memberships = _($scope.group.customer_memberships).reject(function (m) {
            return membership.id === m.id;
          });

          $scope.group.group_admin_memberships = _($scope.group.group_admin_memberships).reject(function (m) {
            return membership.id === m.id;
          });
        })
        .error(function (data, status, headers, config) {
          flashesFactory.add('danger', 'There was a problem revoking the membership.');
        });
    };

    $scope.submitApplication = function (application) {
      var data = {
        submitted_by_id: $scope.userId()
      }

      $http
        .put('/api/internal/accounts/' + $scope.accountSlug() + '/roles/' + $scope.currentRole() + '/applications/' + application.id + '.json', data)
        .success(function (data, status, headers, config) {
          var memberships = $scope.customerMemberships();
          var membership = _(memberships).find(function (membership) {
            return _(membership.applications).find(function (application) {
              return data.application.id === application.id;
            });
          });

          var application = _(membership.applications).find(function (application) {
            return data.application.id === application.id;
          });

          var applicationIndex = membership.applications.indexOf(application);

          membership.applications[applicationIndex] = data.application;
        })
        .error(function (data, status, headers, config) {
          flashesFactory.add('danger', 'There was a problem submitting the application.');
        });
    };

    // TODO: Change eligibility modal to use this format
    $scope.reviewApplication = function (application) {
      $('#review-application-modal').modal('show');

      eventsFactory.emit('review-application', application, $scope.customerMemberships);
    };

    $scope.showApplicationStatus = function (application) {
      $('#enrollment-status-modal').modal('show');

      eventsFactory.emit('enrollment-status', application);
    };

    $scope.addBenefitPlan = function (benefitPlan) {
      var data = {
        benefit_plan_id: benefitPlan.id
      }

      $http
        .post('/api/internal/accounts/' + $scope.accountSlug() + '/roles/' + $scope.currentRole() + '/groups/' + $scope.groupSlug() + '/group_benefit_plans.json', data)
        .success(function (data, status, headers, config) {
          benefitPlan.isEnabled = true;
        })
        .error(function (data, status, headers, config) {
          flashesFactory.add('danger', 'There was a problem adding the benefit plan.');
        });
    };

    $scope.disabledBenefitPlans = function () {
      return _($scope.benefitPlans).select(function (benefitPlan) {
        return !benefitPlan.isEnabled;
      });
    }

    $scope.removeBenefitPlan = function (benefitPlan) {
      $http
        .delete('/api/internal/accounts/' + $scope.accountSlug() + '/roles/' + $scope.currentRole() + '/groups/' + $scope.groupSlug() + '/group_benefit_plans.json?benefit_plan_id=' + benefitPlan.id)
        .success(function (data, status, headers, config) {
          benefitPlan.isEnabled = false;
        })
        .error(function (data, status, headers, config) {
          flashesFactory.add('danger', 'There was a problem removing the benefit plan.');
        });
    };

    function done() {
      if ($scope.benefitPlans && $scope.group) {
        _($scope.benefitPlans).each(function (benefitPlan) {
          benefitPlan.isEnabled = !!_($scope.group.benefit_plans).findWhere({ id: benefitPlan.id });
        });

        $scope.ready();
      }
    }

    $http
      .get('/api/internal/accounts/' + $scope.accountSlug() + '/roles/' + $scope.currentRole() + '/benefit_plans.json')
      .success(function (data, status, headers, config) {
        $scope.benefitPlans = data.benefit_plans;
        done();
      })
      .error(function (data, status, headers, config) {
        flashesFactory.add('danger', 'There was a problem fetching the benefit plans.');
      });

    $http
      .get('/api/internal/accounts/' + $scope.accountSlug() + '/roles/' + $scope.currentRole() + '/groups/' + $scope.groupSlug() + '.json')
      .success(function (data, status, headers, config) {
        $scope.group = data.group;
        $scope.form = JSON.parse($scope.group.properties_data);
        done();
      })
      .error(function (data, status, headers, config) {
        flashesFactory.add('danger', 'There was a problem fetching the group data.');
      });
  }
]);

