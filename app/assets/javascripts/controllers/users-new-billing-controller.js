var congoApp = angular.module('congoApp');

congoApp.controller('UsersNewBillingController', [
  '$scope', '$http', '$location',
  function ($scope, $http, $location) {
    $scope.submit = function () {
      $scope.$broadcast('show-errors-check-validity');

      if ($scope.billingForm.$invalid) { return; }

      $http
        .put('/api/v1/users/' + congo.currentUser.id + '.json', {
          user_properties: {
            card_number: $scope.cardNumber,
            month: $scope.month,
            year: $scope.year,
            cvc: $scope.cvc
          }
        })
        .success(function (data, status, headers, config) {
          $location.path('/users/new_account');
        })
        .error(function (data, status, headers, config) {
          flashesFactory.add('danger', 'There was a problem setting up your payment info.');
        });
    };

    $scope.ready();
  }
]);

