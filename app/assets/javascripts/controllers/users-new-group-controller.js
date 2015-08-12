var congoApp = angular.module('congoApp');

congoApp.controller('UsersNewGroupController', [
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

       var account;


     account = congo.currentUser.accounts[0];


      $http
        .post('/api/internal/accounts/' + account.slug + '/roles/' + account.role.name + '/groups.json', {
          name: $scope.form.name,
          properties: _($scope.form).omit('description_trusted')
        })
        .success(function (data, status, headers, config) {
          //$location.path('/accounts/' + $scope.accountSlug() + '/' + $scope.currentRole() + '/groups');



          $location.path('/accounts/' + account.slug + '/' + account.role.name);

          flashesFactory.add('success', 'Welcome, ' + congo.currentUser.first_name + ' ' + congo.currentUser.last_name + '!');

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



