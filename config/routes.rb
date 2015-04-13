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
    '/accounts/new',

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

    # Admin Carriers
    '/admin/carriers',
    '/admin/carriers/new',
    '/admin/carriers/:carrier_slug',

    # Admin Benefit Plans
    '/admin/benefit_plans/new',
    '/admin/benefit_plans/:carrier_slug',

    # Admin All Accounts
    '/admin/accounts',

    # Admin Invitations
    '/admin/invitations',

    # Admin Features
    '/admin/features',

    # Account home
    '/accounts/:slug/:role',
    '/accounts/:slug/:role/home',
    '/accounts/:slug/:role/settings',
    '/accounts/:slug/:role/reports',
    '/accounts/:slug/:role/contact',

    # Carriers
    '/accounts/:slug/:role/carriers',
    '/accounts/:slug/:role/carriers/new',
    '/accounts/:slug/:role/carriers/:carrier_id',

    # Benefit Plans
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

    # Tokens
    '/accounts/:slug/:role/tokens',

    # Notifications
    '/accounts/:slug/:role/messages',
    '/accounts/:slug/:role/activities'
  ]

  namespace :api do
    # Internal API for Angular app
    namespace :internal do
      # Admin routes
      namespace :admin do
        resources :carriers
        resources :carrier_accounts
        resources :benefit_plans
        resources :invitations
        resources :accounts
        resources :groups

        resources :users do
          post '/crystal_ball', to: 'users#crystal_ball'
        end

        resources :features
      end

      resources :accounts do
        resources :roles do
          resources :carriers do
            post '/activate', to: 'carriers#activate'
            delete '/activate', to: 'carriers#deactivate'
          end

          resources :benefit_plans do
            post '/activate', to: 'carriers#activate'
            delete '/activate', to: 'carriers#deactivate'

            resources :attachments
          end

          resources :eligibilities
          resources :tokens

          resources :applications do
            get '/activities', to: 'applications#activities'
            post '/callback', to: 'applications#callback'
          end

          put '/', to: 'accounts#update'

          resources :groups do
            resources :attachments

            resources :memberships do
              post '/confirmations', to: 'memberships#send_confirmation'
            end

            # Send confirmation to all members of a group
            post '/confirmations_all', to: 'memberships#send_confirmation_to_all'

            post '/group_benefit_plans', to: 'group_benefit_plans#create'
            delete '/group_benefit_plans', to: 'group_benefit_plans#destroy'
          end

          get '/charts/members_status', to: 'charts#members_status'

          get '/notifications/count', to: 'notifications#count'
          resources :notifications
        end
      end

      # User routes
      post '/users/signin', to: 'users#signin'
      delete '/users/signout', to: 'users#signout'
      resources :users do
        put '/invitation', to: 'users#update_invitation'
        put '/account', to: 'users#update_account'
      end
    end

    # External API for third parties
    namespace :v1 do
      resource :sample
    end
  end
end

