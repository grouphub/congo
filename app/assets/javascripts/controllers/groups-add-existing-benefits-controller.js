!function() {
  "use strict";

  angular.module('congoApp').controller('GroupsAddExistingBenefitsController', GroupsAddExistingBenefitsController);

  GroupsAddExistingBenefitsController.$inject = ['$scope', '$http', '$location', 'flashesFactory', 'carrierIdService'];

  function GroupsAddExistingBenefitsController($scope, $http, $location, flashesFactory, carrierIdService){
    // Make sure user is totally signed up before continuing.
    $scope.enforceValidAccount();

    $scope.carrierIdService = carrierIdService;

    $scope.init = function() {
      $scope.search = {
        carriers: '',
        benefitPlans: ''
      };

      $http
        .get('/api/internal/accounts/' + $scope.accountSlug() + '/roles/' + $scope.currentRole() + '/groups/' + $scope.groupSlug() + '.json')
        .success(function (data, status, headers, config) {
          $scope.group = data.group;
        })
        .error(function (data, status, headers, config) {
          var error = (data && data.error) ?
            data.error :
            'There was a problem fetching the group data.';

          flashesFactory.add('danger', error);
        });

      $http
        .get('/api/internal/admin/carriers.json')
        .success(function (data, status, headers, config) {
          $scope.carriers = data.carriers;

          done();
        })
        .error(function (data, status, headers, config) {
          var error = (data && data.error) ?
            data.error :
            'There was a problem fetching the list of carriers.';

          flashesFactory.add('danger', error);
        });

      function done () {
        $scope.ready();
      };
    };

    $scope.carriersToShow = function () {
      if ($scope.search.carriers.length > 0) {
        return _($scope.carriers)
          .select(function (carrier) {
            return carrier.name.toLowerCase()
              .indexOf($scope.search.carriers.toLowerCase()) > -1;
          });
      } else {
        return $scope.carriers;
      }
    };

    $scope.carrierCanBeActivated = function (carrier) {
      return !carrier.carrier_account;
    };

    $scope.openEstablishCarrierConnectionsModal = function(carrierId){
      $scope.carrierIdService.set(carrierId);
      $('#establish-carrier-connection-modal').modal('show', carrierId);
    };

  }
}();
