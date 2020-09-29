module DoorkeeperHelpers
  def authorized_get(url, params: {})
    token = FactoryBot.create(:access_token)
    get url, params: params, headers: {
      "Authorization" => "Bearer %s" % token.token,
    }
  end
end
