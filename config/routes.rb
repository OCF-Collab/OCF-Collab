Rails.application.routes.draw do
  root to: 'search#index'

  get 'login' => 'login#index'
  get 'logout' => 'logout#logout'

  get 'auth/auth0/callback' => 'auth0#callback'
  get 'auth/failure' => 'auth0#failure'

  namespace :request_broker do
    resources :provider_node_agents, only: [:show]
  end
end
