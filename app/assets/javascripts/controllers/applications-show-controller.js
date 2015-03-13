var congoApp = angular.module('congoApp');

congoApp.controller('ApplicationsShowController', [
  '$scope', '$http', '$location',
  function ($scope, $http, $location) {
    // Make sure user is totally signed up before continuing.
    $scope.enforceValidAccount();

    $http
      .get('/api/internal/accounts/' + $scope.accountSlug() + '/roles/' + $scope.currentRole() + '/applications/' + $scope.applicationId() + '.json')
      .success(function (data, status, headers, config) {
        $scope.application = data.application;

        // TODO: Find a better way to update this (directive?)
        (function () {
          var propertiesData = JSON.parse($scope.application.properties_data);

          _(propertiesData).each(function (i, key, hash) {
            var value = hash[key]
            console.log(key, value);

            $('#enrollment-form [name="' + key + '"]').val(value)
          });

          $([
            '#enrollment-form input',
            '#enrollment-form select',
            '#enrollment-form textarea'
          ].join(', ')).attr('disabled', 'disabled');

          $('#enrollment-form input[type=submit]').hide();
          $('#enrollment-form h1').text('Application: ' + $scope.application.benefit_plan.name);
        })();

        $scope.ready();
      })
      .error(function (data, status, headers, config) {
        debugger
      });
  }
]);

