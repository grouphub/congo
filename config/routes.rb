def angular_routes(routes)
  routes.each do |route|
    get route, to: 'home#index'
  end
end

Rails.application.routes.draw do
  get '/index_v1', :to => redirect('/index_v1.html')

  angular_routes [
    # Home
    '/',
    '/home',
    '/accounts',

    # Users
    '/users/signin',
    '/users/new_manager',
    '/users/new_plan',
    '/users/new_billing',
    '/users/new_account',
    '/users/new_customer',
    '/users/:id',

    # Admin home
    '/admin',

    # Carriers
    '/admin/carriers',
    '/admin/carriers/new',
    '/admin/carriers/:carrier_slug',
    '/admin/accounts',
    '/admin/groups',

    # Invitations
    '/admin/invitations',

    # Features
    '/admin/features',

    # Account home
    '/accounts/:slug/:role',
    '/accounts/:slug/:role/home',
    '/accounts/:slug/:role/edit',

    # Account carriers
    '/accounts/:slug/:role/carrier_accounts',
    '/accounts/:slug/:role/carrier_accounts/new',
    '/accounts/:slug/:role/carrier_accounts/:carrier_accounts_id',

    # Benefit plans
    '/accounts/:slug/:role/benefit_plans',
    '/accounts/:slug/:role/benefit_plans/new',
    '/accounts/:slug/:role/benefit_plans/:benefit_plan_id',

    # Groups
    '/accounts/:slug/:role/groups',
    '/accounts/:slug/:role/groups/new',
    '/accounts/:slug/:role/groups/:group_slug',
    '/accounts/:slug/:role/groups/:group_slug/benefit_plans/:benefit_plan_id/applications/new',

    # Applications
    '/accounts/:slug/:role/applications',
    '/accounts/:slug/:role/applications/new',
    '/accounts/:slug/:role/applications/:application_id',

    # Notifications
    '/accounts/:slug/:role/messages',
    '/accounts/:slug/:role/activities'
  ]

  namespace :api do
    namespace :internal do
      # Admin routes
      namespace :admin do
        resources :carriers
        resources :invitations
        resources :accounts
        resources :groups
        resources :features
      end

      resources :accounts do
        resources :roles do
          resources :carrier_accounts
          resources :benefit_plans
          resources :eligibilities
          resources :applications

          put '/', to: 'accounts#update'

          resources :groups do
            resources :memberships do
              post '/confirmations', to: 'memberships#send_confirmation'
            end

            # Send confirmation to all members of a group
            post '/confirmations_all', to: 'memberships#send_confirmation_to_all'

            post '/group_benefit_plans', to: 'group_benefit_plans#create'
            delete '/group_benefit_plans', to: 'group_benefit_plans#destroy'
          end

          get '/properties/carrier_accounts', to: 'properties#carrier_accounts'
          get '/properties/accounts', to: 'properties#accounts'
          get '/properties/carriers', to: 'properties#carriers'
          get '/properties/benefit_plans', to: 'properties#benefit_plans'
          get '/properties/groups', to: 'properties#groups'
        end
      end

      # User routes
      post '/users/signin', to: 'users#signin'
      delete '/users/signout', to: 'users#signout'
      resources :users
    end
  end
end

