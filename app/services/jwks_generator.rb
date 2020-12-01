class JwksGenerator
  def jwks
    {
      keys: [jwk.export],
    }
  end

  def jwk
    @jwk ||= JWT::JWK.new(rsa_keypair)
  end

  def rsa_keypair
    @rsa_keypair ||= OpenSSL::PKey::RSA.new(rsa_key)
  end

  def rsa_key
    ENV["JWT_SECRET"]
  end
end
