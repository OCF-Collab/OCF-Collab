module Api
  class BaseController < ActionController::API
    before_action :doorkeeper_authorize!
  end
end
