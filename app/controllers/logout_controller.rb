class LogoutController < ApplicationController
  include LogoutHelper

  def logout
    Authentication.update_all(enabled: false)
    reset_session
    redirect_to root_path
  end
end
