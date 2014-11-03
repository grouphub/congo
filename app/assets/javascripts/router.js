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
      .when('/accounts/:slug/:role/account_carriers', {
        templateUrl: '/assets/account_carriers/index.html',
        controller: 'AccountCarriersIndexController'
      })
      .when('/accounts/:slug/:role/account_carriers/new', {
        templateUrl: '/assets/account_carriers/new.html',
        controller: 'AccountCarriersNewController'
      })
      .when('/accounts/:slug/:role/account_carriers/:account_carrier_id', {
        templateUrl: '/assets/account_carriers/show.html',
        controller: 'AccountCarriersShowController'
      })
      .when('/accounts/:slug/:role/benefit_plans', {
        templateUrl: '/assets/benefit_plans/index.html',
        controller: 'BenefitPlansIndexController'
      })
      .when('/accounts/:slug/:role/benefit_plans/new', {
        templateUrl: '/assets/benefit_plans/new.html',
        controller: 'BenefitPlansNewController'
      })
      .when('/accounts/:slug/:role/benefit_plans/:benefit_plan_id', {
        templateUrl: '/assets/benefit_plans/show.html',
        controller: 'BenefitPlansShowController'
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
      .when('/accounts/:slug/:role/groups/:group_slug/benefit_plans/:benefit_plan_id/applications/new', {
        templateUrl: '/assets/applications/new.html',
        controller: 'ApplicationsNewController'
      })
      .when('/accounts/:slug/:role/applications', {
        templateUrl: '/assets/applications/index.html',
        controller: 'ApplicationsIndexController'
      })
  }
]);

