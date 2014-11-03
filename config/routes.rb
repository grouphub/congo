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

    # Account home
    '/accounts/:slug/:role',
    '/accounts/:slug/:role/home',

    # Account carriers
    '/accounts/:slug/:role/account_carriers',
    '/accounts/:slug/:role/account_carriers/new',
    '/accounts/:slug/:role/account_carriers/:account_carrier_id',

    # Products
    '/accounts/:slug/:role/products',
    '/accounts/:slug/:role/products/new',
    '/accounts/:slug/:role/products/:product_id',

    # Groups
    '/accounts/:slug/:role/groups',
    '/accounts/:slug/:role/groups/new',
    '/accounts/:slug/:role/groups/:group_slug',
    '/accounts/:slug/:role/groups/:group_slug/products/:product_id/applications/new',
    '/accounts/:slug/:role/applications',

    # Applications
    '/accounts/:slug/:role/applications'

    # Charts
    '/charts'
  ]

  namespace :api do
    namespace :v1 do
      resources :accounts do
        resources :account_carriers
        resources :products
        resources :groups do
          resources :memberships do
            post '/confirmations', to: 'memberships#send_confirmation'
          end

          post '/group_products', to: 'group_products#create'
          delete '/group_products', to: 'group_products#destroy'
        end

        resources :applications
      end

      resources :carriers

      post '/users/signin', to: 'users#signin'
      delete '/users/signout', to: 'users#signout'
      resources :users
    end
  end
end

