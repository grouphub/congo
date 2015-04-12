var congoApp = angular.module('congoApp');

congoApp.controller('UsersNewBillingController', [
  '$scope', '$http', '$location',
  function ($scope, $http, $location) {
    $scope.isLocked = false;

    $scope.submit = function () {
      $scope.isLocked = true;

      $scope.$broadcast('show-errors-check-validity');

      if ($scope.billingForm.$invalid) {
        return;
      }

      $http
        .put('/api/internal/users/' + congo.currentUser.id + '/account.json', {
          account_properties: {
            card_number: $scope.cardNumber,
            month: $scope.month,
            year: $scope.year,
            cvc: $scope.cvc
          }
        })
        .success(function (data, status, headers, config) {
          $location.path('/users/new_account');

          $scope.isLocked = false;
        })
        .error(function (data, status, headers, config) {
          var error = (data && data.error) ?
            data.error :
            'There was a problem setting up your payment info.';

          flashesFactory.add('danger', error);

          $scope.isLocked = false;
        });
    };

    $scope.ready();
  }
]);

