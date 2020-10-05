Rails.application.config.middleware.use OmniAuth::Builder do
  provider(
    :auth0,
    Rails.application.credentials.auth0_client_id,
    Rails.application.credentials.auth0_client_secret,
    Rails.application.credentials.auth0_domain,
    callback_path: '/auth/auth0/callback',
    provider_ignores_state: true,
    authorize_params: {
      scope: 'openid email profile'
    }
  )
end
