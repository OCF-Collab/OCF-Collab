Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  mount Sidekiq::Web, at: "/sidekiq"

  root to: "pages#empty"

  use_doorkeeper do
    # it accepts :authorizations, :tokens, :token_info, :applications and :authorized_applications
    skip_controllers :applications, :authorized_applications
  end

  namespace :auth do
    get :keys
  end

  scope module: "brokerage" do
    match "search" => "search#index", defaults: { format: :json }, via: %i[get post]

    namespace :competencies do
      get :asset_file
    end

    namespace :containers do
      get :search
      get :metadata
      get :asset_file
    end
  end
end
