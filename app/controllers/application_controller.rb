class ApplicationController < ActionController::Base
  if Rails.env.staging? || Rails.env.production?
    http_basic_authenticate_with name: 'testuser', password: 'SECUREpassword123;'
  end
end
