module OmniAuth
  module GovukOneLogin
    # Assists in IDP-initiated logout: https://docs.sign-in.service.gov.uk/integrate-with-integration-environment/managing-your-users-sessions/#respond-to-the-back-channel-logout-request
    # @example IDP-initiated logout in Rails controller using Devise
    #   class OmniauthController < ApplicationController
    #     skip_forgery_protection
    #
    #     def backchannel_logout
    #       return head :bad_request if params[:logout_token].blank?
    #
    #       uid = self.class.backchannel_logout_utility.get_sub(logout_token: params[:logout_token])
    #
    #       return head :bad_request if uid.blank?
    #
    #       user = User.find_by!(uid: uid)
    #       sign_out(user)
    #       head :ok
    #     end
    #
    #     def self.backchannel_logout_utility
    #       @backchannel_logout_utility ||=
    #         OmniAuth::GovukOneLogin::BackchannelLogoutUtility.new(client_id: Rails.configuration.oidc["client_id"], idp_base_url: Rails.configuration.oidc["idp_url"])
    #     end
    #   end
    class BackchannelLogoutUtility
      # Initializes with client_id and one of idp_base_url or idp_configuration.
      # Initializing with idp_base_url and idp_configuration may send an HTTP request to
      # fetch the OpenID configuration. The object should be memoized to avoid sending an
      # HTTP request for each logout.
      def initialize(client_id:, idp_base_url: nil, idp_configuration: nil)
        check_initialize_arguments!(idp_base_url, idp_configuration)

        @client_id = client_id
        @idp_configuration = idp_configuration || OmniAuth::GovukOneLogin::IdpConfiguration.new(idp_base_url: idp_base_url)
      end

      def check_initialize_arguments!(idp_base_url, idp_configuration)
        return if idp_base_url || idp_configuration

        raise ArgumentError, "idp_base_url or idp_configuration must not be nil"
      end

      # @param logout_token [String]
      # @return [String]
      def get_sub!(logout_token:)
        logout_token(logout_token)
        verify_sub
        verify_events_claim

        decoded_logout_token["sub"]
      end

      # @param logout_token [String]
      # @return [String]
      def get_sub(logout_token:)
        get_sub!(logout_token: logout_token)
      rescue Error
        nil
      end

      private

      def decoded_logout_token
        @decoded_logout_token ||= JWT.decode(
          @logout_token,
          @idp_configuration.public_keys,
          true,
          algorithm: %w[ES256 RS256],
          aud: @client_id,
          verify_aud: true,
          verify_iat: true,
          iss: @idp_configuration.idp_base_url,
          verify_iss: true,
          leeway: 10
        ).first
      rescue JWT::ExpiredSignature
        raise LogoutTokenExpMismatchError
      rescue JWT::InvalidAudError
        raise LogoutTokenAudMismatchError
      rescue JWT::InvalidIatError
        raise LogoutTokenIatMismatchError
      rescue JWT::InvalidIssuerError
        raise LogoutTokenIssMismatchError
      end

      def verify_sub
        return true unless decoded_logout_token["sub"].nil? || decoded_logout_token["sub"].empty?

        raise LogoutTokenSubMismatchError
      end

      def verify_events_claim
        if !decoded_logout_token["events"].nil? &&
           decoded_logout_token["events"].is_a?(Hash) &&
           decoded_logout_token["events"].size == 1 &&
           decoded_logout_token["events"].key?("http://schemas.openid.net/event/backchannel-logout") &&
           decoded_logout_token["events"]["http://schemas.openid.net/event/backchannel-logout"] == {}
          return true
        end

        raise LogoutTokenEventsClaimMismatchError
      end

      def logout_token(logout_token)
        @logout_token = logout_token
      end
    end
  end
end
