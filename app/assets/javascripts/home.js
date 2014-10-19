var congoApp = angular.module('congoApp', ['ngRoute']);

congoApp.config([
  '$routeProvider',
  '$locationProvider',
  function ($routeProvider, $locationProvider) {
    $locationProvider.html5Mode(true);

    $routeProvider
      .when('/', {
        templateUrl: '/assets/landing.html',
        controller: 'LandingController'
      })
      .when('/users/new', {
        templateUrl: '/assets/users/new.html',
        controller: 'UsersNewController'
      })
      .when('/accounts/:slug', {
        templateUrl: '/assets/home.html',
        controller: 'HomeController'
      })
      .when('/accounts/:slug/users/signin', {
        templateUrl: '/assets/users/signin.html',
        controller: 'UsersSigninController'
      })
      .when('/accounts/:slug/users/new_manager', {
        templateUrl: '/assets/users/new_manager.html',
        controller: 'UsersNewManagerController'
      })
      .when('/accounts/:slug/products', {
        templateUrl: '/assets/products/index.html',
        controller: 'ProductsIndexController'
      })
      .when('/accounts/:slug/products/new', {
        templateUrl: '/assets/products/new.html',
        controller: 'ProductsNewController'
      });
  }
]);

congoApp.factory('slugFactory', function ($location) {
  return {
    slug: function () {
      var match = $location.path().match(/\/accounts\/([^\/]+)/);

      if (match && match[1] && match[1].length > 0) {
        return match[1];
      }
    }
  }
});

congoApp.directive('autoFocus', function($timeout) {
  return {
    restrict: 'AC',
    link: function($scope, $element) {
      $timeout(function(){
        $element[0].focus();
      }, 0);
    }
  };
});

congoApp.controller('MainController', function ($scope, $http, $location, slugFactory) {
  $scope.isSignedin = function () {
    return !!congo.currentUser;
  };

  $scope.userName = function () {
    return congo.currentUser.name;
  };

  $scope.accounts = function () {
    return congo.currentUser.accounts;
  };

  $scope.slug = function () {
    return slugFactory.slug();
  }

  $scope.$watch('slug()');

  $scope.signout = function () {
    $http
      .delete('/api/v1/users/signout.json')
      .success(function (data, status, headers, config) {
        congo.currentUser = null;

        $location.path('/');
      })
      .error(function (data, status, headers, config) {
        debugger
      });
  };
});

congoApp.controller('LandingController', function ($scope) {

});

congoApp.controller('HomeController', function ($scope) {

});

congoApp.controller('UsersSigninController', function ($scope, $http, $location) {
  $scope.submit = function () {
    $http
      .post('/api/v1/users/signin.json', {
        name: $scope.name,
        password: $scope.password
      })
      .success(function (data, status, headers, config) {
        congo.currentUser = data;

        $location.path('/');
      })
      .error(function (data, status, headers, config) {
        debugger
      });
  };
});

congoApp.controller('UsersNewController', function ($scope, $http, $location) {

});

congoApp.controller('UsersNewManagerController', function ($scope, $http, $location) {
  $scope.submit = function () {
    $http
      .post('/api/v1/users.json', {
        name: $scope.name,
        email: $scope.email,
        password: $scope.password,
        password_confirmation: $scope.password_confirmation,
        type: 'broker'
      })
      .success(function (data, status, headers, config) {
        congo.currentUser = data;

        $location.path('/');
      })
      .error(function (data, status, headers, config) {
        debugger
      });
  };
});

congoApp.controller('ProductsIndexController', function ($scope, $http, $location, slugFactory) {
  var slug = slugFactory.slug();

  $scope.slug = function () {
    return slug;
  };

  $http
    .get('/api/v1/accounts/' + slug + '/products.json')
    .success(function (data, status, headers, config) {
      $scope.products = data.products;
    })
    .error(function (data, status, headers, config) {
      debugger
    });

  $scope.deleteProductAt = function (index) {
    var product = $scope.products[index];

    if (!product) {
      debugger
    }

    $http
      .delete('/api/v1/accounts/' + slug + '/products/' + product.id + '.json')
      .success(function (data, status, headers, config) {
        $scope.products.splice(index, 1);
        debugger
      })
      .error(function (data, status, headers, config) {
        debugger
      });
    };
});

congoApp.controller('ProductsNewController', function ($scope, $http, $location, slugFactory) {
  var slug = slugFactory.slug();

  $scope.submit = function () {
    $http
      .post('/api/v1/accounts/' + slug + '/products.json', {
        name: $scope.name
      })
      .success(function (data, status, headers, config) {
        $location.path('/products');
      })
      .error(function (data, status, headers, config) {
        debugger
      });
  };
});

