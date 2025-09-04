module OmniAuth
  module GovukOneLogin
    class Client
      attr_reader :client_id, :idp_configuration, :private_key,
                  :redirect_uri, :private_key_kid, :signing_algorithm,
                  :scope, :ui_locales, :vtr, :pkce, :userinfo_claims

      def initialize(
        client_id:,
        idp_base_url:,
        private_key:,
        redirect_uri:,
        private_key_kid:,
        signing_algorithm:,
        scope:,
        ui_locales:,
        vtr:,
        pkce:,
        userinfo_claims:
      )
        @client_id = client_id
        @idp_configuration = IdpConfiguration.new(
          idp_base_url: idp_base_url,
          signing_algorithm: signing_algorithm
        )
        @private_key = private_key
        @redirect_uri = redirect_uri
        @private_key_kid = private_key_kid
        @signing_algorithm = signing_algorithm
        @scope = scope
        @ui_locales = ui_locales
        @vtr = vtr
        @pkce = pkce
        @userinfo_claims = userinfo_claims
      end
    end
  end
end
