var congoApp = angular.module('congoApp');

congoApp.controller('BenefitPlansNewController', [
  '$scope', '$http', '$location', '$sce', 'flashesFactory',
  function ($scope, $http, $location, $sce, flashesFactory) {
    // Make sure user is totally signed up before continuing.
    $scope.enforceValidAccount();

    $scope.carriers = null;
    $scope.form = {
      name: null,
      carrier_id: null,
      plan_type: null,
      exchange_plan: null,
      small_group: null,
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

    $scope.isLocked = false;
    
    $scope.submit = function () {
      $scope.isLocked = true;

      $http
        .post('/api/internal/accounts/' + $scope.accountSlug() + '/roles/' + $scope.currentRole() + '/benefit_plans.json', {
          name: $scope.form.name,
          carrier_id: $scope.form.carrier_id,
          properties: _($scope.form).omit('description_trusted'),
          account_benefit_plan_properties: $scope.accountBenefitPlanForm
        })
        .success(function (data, status, headers, config) {
          $location.path('/accounts/' + $scope.accountSlug() + '/' + $scope.currentRole() + '/carriers');

          flashesFactory.add('success', 'Successfully created the benefit plan.');

          $scope.isLocked = false;
        })
        .error(function (data, status, headers, config) {
          var error = (data && data.error) ?
            data.error :
            'There was a problem saving your benefit plan.';

          flashesFactory.add('danger', error);

          $scope.isLocked = false;
        });
    };

    $http
      .get('/api/internal/accounts/' + $scope.accountSlug() + '/roles/' + $scope.currentRole() + '/carriers.json?only_activated=true')
      .success(function (data, status, headers, config) {
        $scope.carriers = data.carriers;
        $scope.form.carrier_id = ($scope.carriers[0] ? $scope.carriers[0].id : null);

        $scope.ready();
      })
      .error(function (data, status, headers, config) {
        var error = (data && data.error) ?
          data.error :
          'There was a problem loading the carriers.';

        flashesFactory.add('danger', error);
      });
  }
]);

