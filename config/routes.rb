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
    '/users/new',
    '/accounts/:account_name',
    '/accounts/:account_name/home',
    '/accounts/:account_name/users/signin',
    '/accounts/:account_name/users/new',
    '/accounts/:account_name/users/new_manager',
    '/accounts/:account_name/products',
    '/accounts/:account_name/products/new',
    '/accounts/:account_name/groups',
    '/accounts/:account_name/groups/new'
  ]

  namespace :api do
    namespace :v1 do
      resources :accounts do
        resources :products
        resources :groups
      end

      post '/users/signin', to: 'users#signin'
      delete '/users/signout', to: 'users#signout'
      resources :users
    end
  end
end

