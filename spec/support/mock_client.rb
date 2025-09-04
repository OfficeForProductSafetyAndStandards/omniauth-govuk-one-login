class MockClient
  attr_reader :client_id, :idp_configuration, :private_key,
              :redirect_uri, :private_key_kid, :signing_algorithm,
              :scope, :ui_locales, :vtr, :pkce, :userinfo_claims

  def initialize(overrides = {})
    @client_id = ClientFixtures.client_id
    @idp_configuration = MockIdpConfiguration.new
    @private_key = ClientFixtures.private_key
    @redirect_uri = ClientFixtures.redirect_uri
    @private_key_kid = ClientFixtures.private_key_kid
    @signing_algorithm = IdpFixtures.signing_algorithm
    @scope = "openid,email"
    @ui_locales = "en"
    @vtr = ["Cl.Cm"]
    @pkce = true
    @userinfo_claims = []

    overrides.each do |key, value|
      instance_variable_set("@#{key}", value)
    end
  end

  def mock_method(method_name, return_value)
    instance_variable_set("@#{method_name}", return_value)
  end
end
