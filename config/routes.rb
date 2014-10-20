def angular_routes(routes)
  routes.each do |route|
    get route, to: 'home#index'
  end
end

Rails.application.routes.draw do
  angular_routes [
    '/',
    '/home',
    '/users/signin',
    '/users/new_manager',
    '/users/new_plan',
    '/users/new_billing',
    '/users/new_account',
    '/users/new_customer',
    '/users/:id',
    '/accounts/:slug',
    '/accounts/:slug/home',
    '/accounts/:slug/products',
    '/accounts/:slug/products/new',
    '/accounts/:slug/groups',
    '/accounts/:slug/groups/new',
    '/accounts/:slug/groups/:group_slug'
  ]

  namespace :api do
    namespace :v1 do
      resources :accounts do
        resources :products
        resources :groups do
          resources :memberships do
            post '/confirmations', to: 'memberships#send_confirmation'
          end

          post '/group_products', to: 'group_products#create'
          delete '/group_products', to: 'group_products#destroy'
        end
      end

      post '/users/signin', to: 'users#signin'
      delete '/users/signout', to: 'users#signout'
      resources :users
    end
  end
end

