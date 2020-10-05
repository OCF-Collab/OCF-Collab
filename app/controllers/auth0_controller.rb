class Auth0Controller < ApplicationController
  def callback
    # OmniAuth places the User Profile information (retrieved by omniauth-auth0) in request.env['omniauth.auth'].
    # In this tutorial, you will store that info in the session, under 'userinfo'.
    # If the id_token is needed, you can get it from session[:userinfo]['credentials']['id_token'].
    # Refer to https://github.com/auth0/omniauth-auth0#auth-hash for complete information on 'omniauth.auth' contents.
    session[:userinfo] = request.env['omniauth.auth']

    Authentication.create(auth: request.env['omniauth.auth'].to_hash, enabled: true)
    redirect_to '/?auth0=success'
  end

  # if user authentication fails on the provider side OmniAuth will redirect to /auth/failure,
  # passing the error message in the 'message' request param.
  def failure
    @error_msg = request.params['message']
  end
end
