var congoApp = angular.module('congoApp');

congoApp.directive('groupBenefitPlansModal', [
  '$http',
  'eventsFactory',
  'flashesFactory',
  function ($http, eventsFactory, flashesFactory) {
    return {
      restrict: 'E',
      replace: true,
      templateUrl: congo.assets['directives/group-benefit-plans-modal.html'],
      link: function ($scope, $element, $attrs) {
        $scope.benefitPlan = null;
        $scope.form = null;

        // TODO: Change eligibility modal to use this format
        eventsFactory.on($scope, 'group-benefit-plan', function (group, benefitPlan) {
          $scope.benefitPlan = benefitPlan;
          $scope.form = {
            broker_id: null
          };
        });

        $scope.submit = function () {
          var data = {
            benefit_plan_id: $scope.benefitPlan.id,
            properties: $scope.form
          }

          $http
            .post('/api/internal/accounts/' + $scope.accountSlug() + '/roles/' + $scope.currentRole() + '/groups/' + $scope.groupSlug() + '/group_benefit_plans.json', data)
            .success(function (data, status, headers, config) {
              $scope.benefitPlan.isEnabled = true;
              $('#group-benefit-plans-modal').modal('hide');
            })
            .error(function (data, status, headers, config) {
              var error = (data && data.error) ?
                data.error :
                'There was a problem adding the benefit plan.';

              flashesFactory.add('danger', error);
            });
        };
      }
    };
  }
]);


