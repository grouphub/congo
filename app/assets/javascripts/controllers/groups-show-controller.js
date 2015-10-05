var congoApp = angular.module('congoApp');

congoApp.controller('GroupsShowController', [
  '$scope', '$http', '$location', '$window', '$cookieStore', '$sce', 'eventsFactory', 'flashesFactory',
  function ($scope, $http, $location, $window, $cookieStore, $sce, eventsFactory, flashesFactory) {
    // Make sure user is totally signed up before continuing.
    $scope.enforceValidAccount();

    // Not the greatest place to put a selector, but c'est la vie.
    $('#show-group-tabs').tab();

    $scope.form = {
      name: null,
      group_id: null,
      tax_id: null,
      description_markdown: null,
      description_html: null,
      description_trusted: null
    };

    $scope.$watch('form.description_markdown', function (string) {
      $scope.form.description_html = marked(string || '');
      $scope.form.description_trusted = $sce.trustAsHtml($scope.form.description_html);
    });

    $scope.currentTab = function () {
      return $cookieStore.get('groups-show-tab') || 'basics';
    };

    $scope.changeTab = function (tabName) {
      $cookieStore.put('groups-show-tab', tabName);
    };

    $scope.submit = function () {
      $http
        .put('/api/internal/accounts/' + $scope.accountSlug() + '/roles/' + $scope.currentRole() + '/groups/' + $scope.groupSlug() + '.json', {
          name: $scope.form.name,
          properties: _($scope.form).omit('description_trusted')
        })
        .success(function (data, status, headers, config) {
          $location
            .path('/accounts/' + $scope.accountSlug() + '/' + $scope.currentRole() + '/groups')
            .replace();

          flashesFactory.add('success', 'Successfully updated the group.');
        })
        .error(function (data, status, headers, config) {
          var error = (data && data.error) ?
            data.error :
            'There was a problem saving your group.';

          flashesFactory.add('danger', error);
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

    $scope.updateMembershipEmail = function (membership) {
      var email = membership.email;
      var data = {
        email: membership.email
      };

      $http
        .put('/api/internal/accounts/' + $scope.accountSlug() + '/roles/' + $scope.currentRole() + '/groups/' + $scope.groupSlug() + '/memberships/' + membership.id + '.json', data)
        .success(function (data, status, headers, config) {
          var newMembership = data.membership;
          membership.email = newMembership.email;
        })
        .error(function (data, status, headers, config) {
          var error = (data && data.error) ?
            data.error :
            'There was a problem updating the member email.';

          flashesFactory.add('danger', error);
        });
    };

    $scope.selectBenefitPlan = function (benefitPlan) {
      if (!benefitPlan) {
        flashesFactory.add('danger', 'We could not find a matching benefit plan.');
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

          $location.path('/accounts/' + $scope.accountSlug() + '/' + $scope.currentRole() + '/groups/' + $scope.groupSlug() + '/benefit_plans/' + benefitPlan.slug + '/applications/new');
        })
        .error(function (data, status, headers, config) {
          var error = (data && data.error) ?
            data.error :
            'There was a problem creating your application.';

          flashesFactory.add('danger', error);
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
          var error = (data && data.error) ?
            data.error :
            'There was a problem declining your application.';

          flashesFactory.add('danger', error);
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
          var error = (data && data.error) ?
            data.error :
            'There was a problem revoking your current application.';

          flashesFactory.add('danger', error);
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
          var error = (data && data.error) ?
            data.error :
            'There was a problem inviting a new member.';

          flashesFactory.add('danger', error);
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
          var error = (data && data.error) ?
            data.error :
            'There was a problem inviting a new group admin.';

          flashesFactory.add('danger', error);
        });
    };

    $scope.sendConfirmation = function (membership) {
      $http
        .post('/api/internal/accounts/' + $scope.accountSlug() + '/roles/' + $scope.currentRole() + '/groups/' + $scope.groupSlug() + '/memberships/' + membership.id + '/confirmations.json')
        .success(function (data, status, headers, config) {
          // TODO: Do something...
        })
        .error(function (data, status, headers, config) {
          var error = (data && data.error) ?
            data.error :
            'There was a problem sending the confirmation.';

          flashesFactory.add('danger', error);
        });
    };

    $scope.sendConfirmations = function () {
      $http
        .post('/api/internal/accounts/' + $scope.accountSlug() + '/roles/' + $scope.currentRole() + '/groups/' + $scope.groupSlug() + '/confirmations_all.json')
        .success(function (data, status, headers, config) {
          // TODO: Do something...
        })
        .error(function (data, status, headers, config) {
          var error = (data && data.error) ?
            data.error :
            'There was a problem sending the confirmations.';

          flashesFactory.add('danger', error);
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
          var error = (data && data.error) ?
            data.error :
            'There was a problem revoking the membership.';

          flashesFactory.add('danger', error);
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
          var error = (data && data.error) ?
            data.error :
            'There was a problem submitting the application.';

          flashesFactory.add('danger', error);
        });
    };

    // TODO: Change eligibility modal to use this format
    $scope.reviewApplication = function (application) {
      if (application.pdf_attachment_url !== null) {
        $window.open(application.pdf_attachment_url, '_blank');
      } else {
        $('#review-application-modal').modal('show');
        eventsFactory.emit('review-application', application, $scope.customerMemberships);
      }
    };

    $scope.deleteApplication = function(application) {
      var request = $http.delete('/api/internal/accounts/' +
                                 $scope.accountSlug() + '/roles/' +
                                 $scope.currentRole() + '/applications/' +
                                 application.id + '.json');

      request.success(function(response) {
        $scope.getGroup();
        flashesFactory.add('success', 'Successfully deleted application.');
      });

      request.error(function(response) {
        flashesFactory.add('danger', 'Could not delete application.');
      });
    };

    $scope.showApplicationStatus = function (application) {
      $('#enrollment-status-modal').modal('show');

      eventsFactory.emit('enrollment-status', application);
    };

    $scope.showGroupDescription = function (group) {
      $('#description-modal').modal('show');

      eventsFactory.emit('description', group);
    };

    $scope.showBenefitPlanDescription = function (benefitPlan) {
      $('#description-modal').modal('show');

      eventsFactory.emit('description', benefitPlan);
    };

    $scope.addBenefitPlan = function (benefitPlan) {
      $('#group-benefit-plans-modal').modal('show');

      eventsFactory.emit('group-benefit-plan', $scope.group, benefitPlan);
    };

    $scope.disabledBenefitPlans = function () {
      return _($scope.benefitPlans).select(function (benefitPlan) {
        return !benefitPlan.isEnabled;
      });
    }

    $scope.removeBenefitPlan = function (benefitPlan) {
      // TODO: Can we pass a data hash instead of a query parameter?
      $http
        .delete('/api/internal/accounts/' + $scope.accountSlug() + '/roles/' + $scope.currentRole() + '/groups/' + $scope.groupSlug() + '/group_benefit_plans.json?benefit_plan_id=' + benefitPlan.id)
        .success(function (data, status, headers, config) {
          benefitPlan.isEnabled = false;
        })
        .error(function (data, status, headers, config) {
          var error = (data && data.error) ?
            data.error :
            'There was a problem removing the benefit plan.';

          flashesFactory.add('danger', error);
        });
    };

    $scope.historyApplications = null;

    function done() {
      if ($scope.currentRole() === 'customer') {
        if (!$scope.historyApplications) {
          return;
        }
      }

      if ($scope.benefitPlans && $scope.group) {
        _($scope.benefitPlans).each(function (benefitPlan) {
          benefitPlan.isEnabled = !!_($scope.group.benefit_plans).findWhere({ id: benefitPlan.id });
        });

        $scope.ready();
      }
    }

    $scope.getGroup = function() {
      $http.
        get('/api/internal/accounts/' + $scope.accountSlug() + '/roles/' + $scope.currentRole() + '/groups/' + $scope.groupSlug() + '.json').
        success(function (data, status, headers, config) {
        $scope.group = data.group;
        $scope.form = JSON.parse($scope.group.properties_data);
        done();
      }).error(function (data, status, headers, config) {
        var error = (data && data.error) ?
          data.error :
          'There was a problem fetching the group data.';

        flashesFactory.add('danger', error);
      });
    };

    $http
      .get('/api/internal/accounts/' + $scope.accountSlug() + '/roles/' + $scope.currentRole() + '/benefit_plans.json?only_activated=true')
      .success(function (data, status, headers, config) {
        $scope.benefitPlans = data.benefit_plans;
        done();
      })
      .error(function (data, status, headers, config) {
        var error = (data && data.error) ?
          data.error :
          'There was a problem fetching the benefit plans.';

        flashesFactory.add('danger', error);
      });

    $scope.getGroup();

    if ($scope.currentRole() === 'customer') {
      $http
        .get('/api/internal/accounts/' + $scope.accountSlug() + '/roles/' + $scope.currentRole() + '/applications.json')
        .success(function (data, status, headers, config) {
          $scope.historyApplications = data.applications;

          done();
        })
        .error(function (data, status, headers, config) {
          var error = (data && data.error) ?
            data.error :
            'There was a problem fetching the list of applications.';

          flashesFactory.add('danger', error);
        });
    }

    // ===========
    // Attachments
    // ===========

    $scope.attachmentFormData = {
      title: null,
      description: null
    };

    $scope.file = {
      name: ''
    };

    $scope.fileChanged = function (e) {
      $scope.$apply(function () {
        $scope.file.name = (e.files && e.files[0]) ? e.files[0].name : '';
      });
    };

    $scope.newAttachment = function () {
      var fileInput = $('#new-attachment').find('[type="file"]');
      var file = fileInput[0].files[0];
      var formData = new FormData();

      formData.append('file', file);
      formData.append('properties', JSON.stringify($scope.attachmentFormData));

      $http
        .post('/api/internal/accounts/' + $scope.accountSlug() + '/roles/' + $scope.currentRole() + '/groups/' + $scope.groupSlug() + '/attachments.json', formData, {
          withCredentials: true,
          headers: {
            'Content-Type': undefined
          },
          transformRequest: angular.identity
        })
        .success(function (data, status, headers, config) {
          $scope.group.attachments.push(data.attachment);

          fileInput[0].value = null;
          $scope.file.name = '';
        })
        .error(function (data, status, headers, config) {
          var error = (data && data.error) ?
            data.error :
            'There was a problem uploading the file.';

          flashesFactory.add('danger', error);
        });
    };

    $scope.deleteAttachmentAt = function (index) {
      var attachment = $scope.group.attachments[index];

      $http
        .delete('/api/internal/accounts/' + $scope.accountSlug() + '/roles/' + $scope.currentRole() + '/groups/' + $scope.groupSlug() + '/attachments/' + attachment.id + '.json')
        .success(function (data, status, headers, config) {
          $scope.group.attachments = _($scope.group.attachments).reject(function (deletedAttachment) {
            return attachment.id === deletedAttachment.id;
          });
        })
        .error(function (data, status, headers, config) {
          var error = (data && data.error) ?
            data.error :
            'There was a problem deleting the attachment.';

          flashesFactory.add('danger', error);
        });
    }

    // -------------------
    // Application History
    // -------------------
    //

    $scope.uploadApplication = function(membership) {
      $('#upload-application-modal').modal('show');
      $scope.$emit('modal.upload-application', membership, $scope.benefitPlans);
    };


    $scope.revokeApplication = function (application) {
      if (!application) {
        flashesFactory.add('danger', 'We could not find a matching invitation.');
      }

      $http
        .delete('/api/internal/accounts/' + $scope.accountSlug() + '/roles/' + $scope.currentRole() + '/applications/' + application.id + '.json')
        .success(function (data, status, headers, config) {
          $scope.historyapplications = _($scope.applications).reject(function (a) {
            return application.id === a.id;
          });
        })
        .error(function (data, status, headers, config) {
          var error = (data && data.error) ?
            data.error :
            'There was a problem revoking the application.';

          flashesFactory.add('danger', error);
        });
    };
  }
]);

