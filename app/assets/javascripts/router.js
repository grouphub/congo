var congoApp = angular.module('congoApp');

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
      .when('/users/new_manager', {
        templateUrl: '/assets/users/new_manager.html',
        controller: 'UsersNewManagerController'
      })
      .when('/users/new_plan', {
        templateUrl: '/assets/users/new_plan.html',
        controller: 'UsersNewPlanController'
      })
      .when('/users/new_billing', {
        templateUrl: '/assets/users/new_billing.html',
        controller: 'UsersNewBillingController'
      })
      .when('/users/new_account', {
        templateUrl: '/assets/users/new_account.html',
        controller: 'UsersNewAccountController'
      })
      .when('/users/new_customer', {
        templateUrl: '/assets/users/new_customer.html',
        controller: 'UsersNewCustomerController'
      })
      .when('/users/signin', {
        templateUrl: '/assets/users/signin.html',
        controller: 'UsersSigninController'
      })
      .when('/users/:id', {
        templateUrl: '/assets/users/show.html',
        controller: 'UsersShowController'
      })
      .when('/admin', {
        templateUrl: '/assets/home.html',
        controller: 'HomeController'
      })
      .when('/admin/carriers', {
        templateUrl: '/assets/carriers/index.html',
        controller: 'CarriersIndexController'
      })
      .when('/admin/carriers/new', {
        templateUrl: '/assets/carriers/new.html',
        controller: 'CarriersNewController'
      })
      .when('/admin/carriers/:carrier_slug', {
        templateUrl: '/assets/carriers/show.html',
        controller: 'CarriersShowController'
      })
      .when('/accounts/:slug/:role', {
        templateUrl: '/assets/home.html',
        controller: 'HomeController'
      })
      .when('/accounts/:slug/:role/products', {
        templateUrl: '/assets/products/index.html',
        controller: 'ProductsIndexController'
      })
      .when('/accounts/:slug/:role/products/new', {
        templateUrl: '/assets/products/new.html',
        controller: 'ProductsNewController'
      })
      .when('/accounts/:slug/:role/products/:product_id', {
        templateUrl: '/assets/products/show.html',
        controller: 'ProductsShowController'
      })
      .when('/accounts/:slug/:role/groups', {
        templateUrl: '/assets/groups/index.html',
        controller: 'GroupsIndexController'
      })
      .when('/accounts/:slug/:role/groups/new', {
        templateUrl: '/assets/groups/new.html',
        controller: 'GroupsNewController'
      })
      .when('/accounts/:slug/:role/groups/:group_slug', {
        templateUrl: '/assets/groups/show.html',
        controller: 'GroupsShowController'
      })
      .when('/accounts/:slug/:role/groups/:group_slug/products/:product_id/applications/new', {
        templateUrl: '/assets/applications/new.html',
        controller: 'ApplicationsNewController'
      })
      .when('/accounts/:slug/:role/applications', {
        templateUrl: '/assets/applications/index.html',
        controller: 'ApplicationsIndexController'
      })
  }
]);

