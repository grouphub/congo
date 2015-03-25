var congoApp = angular.module('congoApp');

congoApp.controller('AdminBenefitPlansNewController', [
  '$scope', '$http', '$location', '$sce', 'flashesFactory',
  function ($scope, $http, $location, $sce, flashesFactory) {
    // Make sure user is admin before continuing.
    $scope.enforceAdmin();

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

    $scope.$watch('form.description_markdown', function (string) {
      $scope.form.description_html = marked(string || '');
      $scope.form.description_trusted = $sce.trustAsHtml($scope.form.description_html);
    });
    
    $scope.submit = function () {
      $http
        .post('/api/internal/admin/benefit_plans.json', {
          name: $scope.form.name,
          carrier_account_id: $scope.form.carrier_account_id,
          properties: _($scope.form).omit('description_trusted')
        })
        .success(function (data, status, headers, config) {
          $location.path('/admin/benefit_plans');
        })
        .error(function (data, status, headers, config) {
          var error = (data && data.error) ?
            data.error :
            'There was a problem saving your benefit plan.';

          flashesFactory.add('danger', error);
        });
    };

    $http
      .get('/api/internal/admin/carrier_accounts.json')
      .success(function (data, status, headers, config) {
        $scope.carrierAccounts = data.carrier_accounts;
        $scope.form.carrier_account_id = $scope.carrierAccounts[0].id;

        $scope.ready();
      })
      .error(function (data, status, headers, config) {
        var error = (data && data.error) ?
          data.error :
          'There was a problem loading the carrier accounts.';

        flashesFactory.add('danger', error);
      });
  }
]);

