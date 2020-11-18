module Api
  class BaseController < ActionController::API
    before_action :doorkeeper_authorize!

    rescue_from StandardError do |exception|
      render json: { :error => exception.message }, :status => 500
    end
  end
end
