var congoApp = angular.module('congoApp');

congoApp.controller('BenefitPlansShowController', [
  '$scope', '$http', '$location', '$timeout', '$sce', 'flashesFactory',
  function ($scope, $http, $location, $timeout, $sce, flashesFactory) {
    $scope.benefitPlan = null;
    $scope.carriers = null;
    $scope.form = {
      name: null,
      carrier_id: null,
      plan_type: null,
      exchange_plan: null,
      small_group: null,
      group_id: null,
      description_markdown: null,
      description_html: null,
      description_trusted: null
    };

    $scope.accountBenefitPlanForm = {

    };

    $scope.$watch('form.description_markdown', function (string) {
      $scope.form.description_html = marked(string || '');
      $scope.form.description_trusted = $sce.trustAsHtml($scope.form.description_html);
    });

    $scope.submit = function () {
      $http
        .put('/api/internal/accounts/' + $scope.accountSlug() + '/roles/' + $scope.currentRole() + '/benefit_plans/' + $scope.benefitPlanSlug() + '.json', {
          name: $scope.form.name,
          carrier_id: $scope.form.carrier_id,
          properties: _($scope.form).omit('description_trusted'),
          account_benefit_plan_properties: $scope.accountBenefitPlanForm
        })
        .success(function (data, status, headers, config) {
          $location.path('/accounts/' + $scope.accountSlug() + '/' + $scope.currentRole() + '/carriers');

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
      .get('/api/internal/accounts/' + $scope.accountSlug() + '/roles/' + $scope.currentRole() + '/benefit_plans/' + $scope.benefitPlanSlug() + '.json')
      .success(function (data, status, headers, config) {
        $scope.benefitPlan = data.benefit_plan;
        $scope.form = JSON.parse($scope.benefitPlan.properties_data);
        $scope.form.carrier_id = $scope.benefitPlan.carrier_id;

        $http
          .get('/api/internal/admin/carriers.json')
          .success(function (data, status, headers, config) {
            $scope.carriers = data.carriers;

            // TODO: This is not the right way to do this, but I can't get the select to behave.
            $timeout(function () {
              $('.benefit-plans-show form #carrier').val($scope.benefitPlan.carrier_id);
            });

            $scope.ready();
          })
          .error(function (data, status, headers, config) {
            var error = (data && data.error) ?
              data.error :
              'There was a problem loading the list of carriers.';

            flashesFactory.add('danger', error);
          });
      })
      .error(function (data, status, headers, config) {
        var error = (data && data.error) ?
          data.error :
          'There was a problem loading your benefit plan.';

        flashesFactory.add('danger', error);
      });
  }
]);

