Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  root to: "pages#empty"

  use_doorkeeper do
    # it accepts :authorizations, :tokens, :token_info, :applications and :authorized_applications
    skip_controllers :applications, :authorized_applications
  end

  namespace :auth do
    get :keys
  end

  scope module: "brokerage" do
    namespace :competency_frameworks do
      get :search
      get :metadata
      get :asset_file
    end
  end
end
