var congoApp = angular.module('congoApp');

congoApp.controller('TokensIndexController', [
  '$scope',
  '$location',
  '$http',
  'flashesFactory',
  function ($scope, $location, $http, flashesFactory) {
    $scope.tokens = null;

    $scope.form = {
      name: undefined
    };

    $scope.newToken = function () {
      $http
        .post('/api/internal/accounts/' + $scope.accountSlug() + '/roles/' + $scope.currentRole() + '/tokens.json', {
          name: $scope.form.name
        })
        .success(function (data, status, headers, config) {
          $scope.tokens.push(data.token);
          $scope.form.name = '';
        })
        .error(function (data, status, headers, config) {
          flashesFactory.add('danger', 'There was a problem creating a new token.');
        });
    };

    $scope.deleteTokenAt = function (index) {
      var token = $scope.tokens[index];

      if (!token) {
        flashesFactory.add('danger', 'There was a problem deleting the token.');
      }

      $http
        .delete('/api/internal/accounts/' + $scope.accountSlug() + '/roles/' + $scope.currentRole() + '/tokens/' + token.id + '.json')
        .success(function (data, status, headers, config) {
          $scope.tokens.splice(index, 1);
        })
        .error(function (data, status, headers, config) {
          flashesFactory.add('danger', 'There was a problem deleting the token.');
        });
    };

    $http
      .get('/api/internal/accounts/' + $scope.accountSlug() + '/roles/' + $scope.currentRole() + '/tokens.json')
      .success(function (data, status, headers, config) {
        $scope.tokens = data.tokens;

        $scope.ready();
      })
      .error(function (data, status, headers, config) {
        flashesFactory.add('danger', 'There was a problem fetching the tokens.');
      });
  }
]);


