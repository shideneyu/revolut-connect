require "jwt"

module Revolut
  class Auth < BaseModel
    class NotAuthorizedError < StandardError
      def initialize
        super(
          "You need to authorize your app to access the Revolut business account of the user\n" \
            "Please visit #{Revolut::Auth.authorize_url} to get an authorization code that you can then use with the Revolut::Auth.retrieve method to get an access token."
        )
      end
    end

    class << self
      attr_accessor :token_type, :expires_at, :refresh_token
      attr_writer :access_token

      # Use this URI to redirect the user to Revolut's authorization page
      # to authorize your app to access her business account.
      def authorize_url
        "#{authorize_base_uri}?client_id=#{Revolut.config.client_id}&redirect_uri=#{Revolut.config.authorize_redirect_uri}&response_type=code#authorise"
      end

      def retrieve(authorization_code:)
        new(http_client.get_access_token(authorization_code:).body).tap do |authorization|
          @access_token = authorization.access_token
          @token_type = authorization.token_type
          @expires_at = Time.now.to_i + authorization.expires_in
          @refresh_token = authorization.refresh_token
        end
      end

      def access_token
        # If there's no token set in the authorization class, it means that we're trying to
        # access the API without having gone through the authorization process.
        raise Revolut::Auth::NotAuthorizedError if @access_token.nil?

        refresh if expired?

        @access_token
      end

      def expired?
        expires_at && Time.now.to_i >= expires_at
      end

      private

      def refresh
        return unless expired?

        new(http_client.refresh_access_token(refresh_token:).body).tap do |refreshed_auth|
          @access_token = refreshed_auth.access_token
          @token_type = refreshed_auth.token_type
          @expires_at = Time.now.to_i + refreshed_auth.expires_in
        end
      end

      def authorize_base_uri
        Revolut.sandbox? ?
          "https://sandbox-business.revolut.com/app-confirm" :
          "https://business.revolut.com/app-confirm"
      end
    end
  end
end
