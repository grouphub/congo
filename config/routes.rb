def angular_routes(routes)
  routes.each do |route|
    get route, to: 'home#index'
  end
end

Rails.application.routes.draw do
  root 'home#index'

  angular_routes [
    '/home',
    '/users/signin',
    '/users/new',
    '/users/new_manager',
    '/products',
    '/products/new'
  ]

  namespace :api do
    namespace :v1 do
      post '/users/signin', to: 'users#signin'
      delete '/users/signout', to: 'users#signout'
      resources :users

      resources :products
    end
  end
end

