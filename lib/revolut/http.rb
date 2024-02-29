require "uri"

module Revolut
  module HTTP
    def get(path, headers: {}, **query)
      full_uri = uri(path:, query:)

      conn.get(full_uri) do |req|
        req.headers = all_headers(headers)
      end
    end

    def post(path, data: {}, headers: {}, **query)
      full_uri = uri(path:, query:)

      conn(content_type).post(full_uri) do |req|
        req.body = data.to_json if data.any?
        req.headers = all_headers(headers)
      end
    end

    def put(path, data: {}, headers: {}, **query)
      full_uri = uri(path:, query:)

      conn.put(full_uri) do |req|
        req.body = data.to_json if data.any?
        req.headers = all_headers(headers)
      end
    end

    def delete(path, headers: {}, **query)
      full_uri = uri(path:, query:)

      conn.delete(full_uri) do |req|
        req.headers = all_headers(headers)
      end
    end

    def get_access_token(authorization_code:)
      full_uri = uri(path: "auth/token")

      conn(:url_encoded).post(full_uri) do |req|
        req.headers = global_headers
        req.body = URI.encode_www_form({
          grant_type: "authorization_code",
          code: authorization_code,
          client_assertion_type: "urn:ietf:params:oauth:client-assertion-type:jwt-bearer",
          client_assertion:
        })
      end
    end

    def refresh_access_token(refresh_token:)
      full_uri = uri(path: "auth/token")

      conn(:url_encoded).post(full_uri) do |req|
        req.headers = global_headers
        req.body = URI.encode_www_form({
          grant_type: "refresh_token",
          refresh_token:,
          client_assertion_type: "urn:ietf:params:oauth:client-assertion-type:jwt-bearer",
          client_assertion:
        })
      end
    end

    private

    def conn(content_type = :json)
      Faraday.new do |f|
        f.options[:timeout] = request_timeout
        f.request content_type
        f.response :json
        f.response :raise_error
      end
    end

    def uri(path:, query: {})
      File.join(base_uri, path) + "?#{URI.encode_www_form(query)}"
    end

    def all_headers(request_headers = {})
      {
        "Authorization" => "Bearer #{access_token}"
      }.merge(global_headers).merge(request_headers)
    end

    def client_assertion
      private_key = OpenSSL::PKey::RSA.new(signing_key)

      payload = {
        iss:,
        sub: client_id,
        aud: "https://revolut.com",
        exp: Time.now.to_i + 120 # Expires in 2 minutes
      }

      header = {
        alg: "RS256",
        typ: "JWT"
      }

      JWT.encode(payload, private_key, "RS256", header)
    end
  end
end
