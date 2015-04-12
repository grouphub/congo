var congoApp = angular.module('congoApp');

congoApp.controller('GroupsNewController', [
  '$scope', '$http', '$location', '$sce', 'flashesFactory',
  function ($scope, $http, $location, $sce, flashesFactory) {
    // Make sure user is totally signed up before continuing.
    $scope.enforceValidAccount();

    $scope.form = {
      name: null,
      group_id: null,
      description_markdown: null,
      description_html: null,
      description_trusted: null
    };

    $scope.$watch('form.description_markdown', function (string) {
      $scope.form.description_html = marked(string || '');
      $scope.form.description_trusted = $sce.trustAsHtml($scope.form.description_html);
    });

    $scope.isLocked = false;

    $scope.submit = function () {
      $scope.isLocked = true;

      $http
        .post('/api/internal/accounts/' + $scope.accountSlug() + '/roles/' + $scope.currentRole() + '/groups.json', {
          name: $scope.form.name,
          properties: _($scope.form).omit('description_trusted')
        })
        .success(function (data, status, headers, config) {
          $location.path('/accounts/' + $scope.accountSlug() + '/' + $scope.currentRole() + '/groups');

          // TODO: Does this need to be here?
          $scope.ready();

          $scope.isLocked = false;
        })
        .error(function (data, status, headers, config) {
          var error = (data && data.error) ?
            data.error :
            'There was a problem creating the group.';

          flashesFactory.add('danger', error);

          $scope.isLocked = false;
        });
    };

    $scope.ready();
  }
]);

