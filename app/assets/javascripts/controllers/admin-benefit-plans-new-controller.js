var congoApp = angular.module('congoApp');

congoApp.controller('AdminBenefitPlansNewController', [
  '$scope', '$http', '$location', '$sce', 'flashesFactory',
  function ($scope, $http, $location, $sce, flashesFactory) {
    // Make sure user is admin before continuing.
    $scope.enforceAdmin();

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

    $scope.$watch('form.description_markdown', function (string) {
      $scope.form.description_html = marked(string || '');
      $scope.form.description_trusted = $sce.trustAsHtml($scope.form.description_html);
    });
    
    $scope.submit = function () {
      $http
        .post('/api/internal/admin/benefit_plans.json', {
          name: $scope.form.name,
          carrier_id: $scope.form.carrier_id,
          properties: _($scope.form).omit('description_trusted')
        })
        .success(function (data, status, headers, config) {
          $location.path('/admin/carriers');
        })
        .error(function (data, status, headers, config) {
          var error = (data && data.error) ?
            data.error :
            'There was a problem saving your benefit plan.';

          flashesFactory.add('danger', error);
        });
    };

    $http
      .get('/api/internal/admin/carriers.json')
      .success(function (data, status, headers, config) {
        $scope.carriers = data.carriers;
        $scope.form.carrier_id = $scope.carriers[0].id;

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

