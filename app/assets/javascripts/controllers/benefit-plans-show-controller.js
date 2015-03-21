var congoApp = angular.module('congoApp');

congoApp.controller('BenefitPlansShowController', [
  '$scope', '$http', '$location', '$timeout', '$sce', 'flashesFactory',
  function ($scope, $http, $location, $timeout, $sce, flashesFactory) {
    // Make sure user is totally signed up before continuing.
    $scope.enforceValidAccount();

    $scope.carrierAccounts = null;
    $scope.form = {
      name: null,
      carrier_account_id: null,
      plan_type: null,
      exchange_plan: null,
      small_group: null,
      description_markdown: null,
      description_html: null,
      description_trusted: null
    };

    $scope.benefitPlan = null;

    $scope.$watch('form.description_markdown', function (string) {
      $scope.form.description_html = marked(string || '');
      $scope.form.description_trusted = $sce.trustAsHtml($scope.form.description_html);
    });

    $scope.submit = function () {
      $http
        .put('/api/internal/accounts/' + $scope.accountSlug() + '/roles/' + $scope.currentRole() + '/benefit_plans/' + $scope.benefitPlanId() + '.json', {
          name: $scope.form.name,
          carrier_account_id: $scope.form.carrier_account_id,
          properties: _($scope.form).omit('description_trusted')
        })
        .success(function (data, status, headers, config) {
          $location.path('/accounts/' + $scope.accountSlug() + '/' + $scope.currentRole() + '/benefit_plans');

          flashesFactory.add('success', 'Successfully updated the benefit plan.');
        })
        .error(function (data, status, headers, config) {
          var error = (data && data.error) ?
            data.error :
            'There was a problem loading your benefit plan.';

          flashesFactory.add('danger', error);
        });
    };

    $http
      .get('/api/internal/accounts/' + $scope.accountSlug() + '/roles/' + $scope.currentRole() + '/benefit_plans/' + $scope.benefitPlanId() + '.json')
      .success(function (data, status, headers, config) {
        $scope.benefitPlan = data.benefit_plan;
        $scope.form = JSON.parse($scope.benefitPlan.properties_data);
        $scope.form.carrier_account_id = $scope.benefitPlan.carrier_account_id;

        $http
          .get('/api/internal/accounts/' + $scope.accountSlug() + '/roles/' + $scope.currentRole() + '/carrier_accounts.json')
          .success(function (data, status, headers, config) {
            $scope.carrierAccounts = data.carrier_accounts;

            // TODO: This is not the right way to do this, but I can't get the select to behave.
            $timeout(function () {
              $('.benefit-plans-show form #carrier_account').val($scope.benefitPlan.carrier_account_id);
            });

            $scope.ready();
          })
          .error(function (data, status, headers, config) {
            var error = (data && data.error) ?
              data.error :
              'There was a problem loading the list of carrier accounts.';

            flashesFactory.add('danger', error);
          });
      })
      .error(function (data, status, headers, config) {
        var error = (data && data.error) ?
          data.error :
          'There was a problem loading your benefit plan.';

        flashesFactory.add('danger', error);
      });

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
        .post('/api/internal/accounts/' + $scope.accountSlug() + '/roles/' + $scope.currentRole() + '/benefit_plans/' + $scope.benefitPlanId() + '/attachments.json', formData, {
          withCredentials: true,
          headers: {
            'Content-Type': undefined
          },
          transformRequest: angular.identity
        })
        .success(function (data, status, headers, config) {
          $scope.benefitPlan.attachments.push(data.attachment);
      
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
      var attachment = $scope.benefitPlan.attachments[index];

      $http
        .delete('/api/internal/accounts/' + $scope.accountSlug() + '/roles/' + $scope.currentRole() + '/benefit_plans/' + $scope.benefitPlanId() + '/attachments/' + attachment.id + '.json')
        .success(function (data, status, headers, config) {
          $scope.benefitPlan.attachments = _($scope.benefitPlan.attachments).reject(function (deletedAttachment) {
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
  }
]);
