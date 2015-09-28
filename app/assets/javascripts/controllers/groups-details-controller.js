var congoApp = angular.module('congoApp');

congoApp.controller('GroupsDetailsController', [
  '$scope', '$http', '$location', 'flashesFactory',
  function ($scope, $http, $location, flashesFactory) {
    // Make sure user is totally signed up before continuing.
    $scope.enforceValidAccount();

    $scope.form = {
      number_of_members: null,
      industry: null,
      website: null,
      phone_number: null,
      zip_code: null,
      tax_id: null
    };

    $scope.number_of_members = [
      {id: '1', desc: '1'},
      {id: '2', desc: '2'},
      {id: '3', desc: '3'},
      {id: '4', desc: '4'},
      {id: '5', desc: '5'},
      {id: '6', desc: '6'},
      {id: '7', desc: '7'},
      {id: '8', desc: '8'},
      {id: '9', desc: '9'},
      {id: '10',desc: '10'},
      {id: '11',desc: '11'}
    ];

    $scope.industries = [
      {id: 'agriculture', desc: 'Agriculture/Foresty'},
      {id: 'automotive', desc: 'Automotive'},
      {id: 'finance_and_insurance', desc: 'Finance and Insurance'},
      {id: 'restaurant', desc: 'Restaurant/Foodservice'},
      {id: 'health_care_and_social_assistance', desc: 'Health Care and Social Assistance'},
      {id: 'hospitality', desc: 'Hospitality'},
      {id: 'manufacturing', desc: 'Manufacturing'},
      {id: 'retail', desc: 'Retail'},
      {id: 'insurance_services', desc: 'Insurance Services'},
      {id: 'Telecommunications', desc: 'Telecommunications'},
      {id: 'accommodation', desc: 'Accommodation'},
      {id: 'non_profit_charity_volunteers', desc: 'Non-profit/Charity/Volunteers'},
      {id: 'education', desc: 'Education'},
      {id: 'arts_entertainment_and_recreation', desc: 'Arts, Entertainment & Recreation'},
      {id: 'call_centre', desc: 'Call Centre'},
      {id: 'consultant', desc: 'Consultant'},
      {id: 'emergency_services', desc: 'Emergency Services'},
      {id: 'government_public_administration', desc: 'Government/Public Administration'},
      {id: 'home_improvement_services', desc: 'Home Improvement Services'},
      {id: 'information_technology', desc: 'Information Technology'},
      {id: 'media', desc: 'Media'},
      {id: 'mining_oil_and_gas', desc: 'Mining, Oil and Gas'},
      {id: 'reseller_white_label', desc: 'Reseller/White Label'},
      {id: 'security_services', desc: 'Security Services'},
      {id: 'software', desc: 'Software'},
      {id: 'transportation_logistics', desc: 'Transportation/Logistics'},
      {id: 'utilities', desc: 'Utilities'},
      {id: 'wholesaler', desc: 'Wholesaler'},
      {id: 'police_department', desc: 'Police Department'},
      {id: 'other', desc: 'Other'}
    ];

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

    $scope.isLocked = false;

    $scope.submit = function () {
      $scope.isLocked = true;

      $http
        .put('/api/internal/accounts/' + $scope.accountSlug() + '/roles/' + $scope.currentRole() + '/groups/' + $scope.groupSlug() + '.json', {
          number_of_members: $scope.form.number_of_members,
          industry:          $scope.form.industry,
          website:           $scope.form.website,
          phone_number:      $scope.form.phone_number,
          zip_code:          $scope.form.zip_code,
          tax_id:            $scope.form.tax_id
        })
        .success(function (data, status, headers, config) {
          $location.path('/accounts/' + $scope.accountSlug() + '/' + $scope.currentRole() + '/groups/' + data.group.slug + '/members');

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

