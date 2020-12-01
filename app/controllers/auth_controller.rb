class AuthController < ApplicationController
  def keys
    render json: JwksGenerator.new.jwks
  end
end
