module DoorkeeperHelpers
  def authorized_get(url, access_token: nil, params: {})
    token = access_token || FactoryBot.create(:access_token)
    get url, params: params, headers: {
      "Authorization" => "Bearer %s" % token.token,
    }
  end
end
