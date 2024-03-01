# Revolut Connect

<!-- <a href="https://codecov.io/github/moraki-finance/docuseal" >
 <img src="https://codecov.io/github/moraki-finance/docuseal/graph/badge.svg?token=SKTT14JJGV"/>
</a> -->

<!-- [![Tests](https://github.com/moraki-finance/docuseal/actions/workflows/main.yml/badge.svg?branch=main)](https://github.com/moraki-finance/docuseal/actions/workflows/main.yml) -->

A lightweight API connector for Revolut. Revolut docs: https://developer.revolut.com/

:warning: The extracted API objects don't do input parameters validations. It's a simple faraday wrapper that allows you to send as many inputs as you want. The docuseal API might fail when passing a wrong set of parameters.

:warning: For now this connector only supports the [Business API](https://developer.revolut.com/docs/business/business-api). Pull requests are welcomed to support other APIs.

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add revolut-connect

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install revolut-connect

## Usage

### First Time Authorization

1) Generate a certificate for your API integration and register the API into your Revolut business account by following [this tutorial](https://developer.revolut.com/docs/guides/manage-accounts/get-started/make-your-first-api-request#1-add-your-certificate).

2) From the step above, you'll need to copy the `client id`, the `private key` and the `iss` values that Revolut asks you to generate. We'll set these as environment variables as follows:

```
REVOLUT_CLIENT_ID={YOUR APP CLIENT ID}
REVOLUT_SIGNING_KEY="{YOUR APP SIGNING KEY IN ONE LINE JOINED BY NEW LINES (e.g: -----BEGIN PRIVATE KEY-----\n....)}"
REVOLUT_ISS={YOUR ISS}
```

3) Set the Revolut authorization redirect URI. This URI is what Revolut will use to redirect to after the user has authorized the API to access the account. Revolut will redirect to this URL adding a `code` query param that we'll need to exchange for the first access token ([reference](https://developer.revolut.com/docs/guides/manage-accounts/get-started/make-your-first-api-request#3-consent-to-the-application)):

```
REVOLUT_AUTHORIZE_REDIRECT_URI={YOUR REVOLUT AUTH HANDLING DOMAIN}
```

4) In revolut, after adding all the API details (uploading the certificate, iss, etc), enable the API. This will take you to the APP authorization consent form. After you authorize the app, you should be redirected to the domain you set in the configuration with the authorization `code` in query params. Copy this code.

![Screenshot 2024-03-01 at 6 45 45 AM](https://github.com/moraki-finance/revolut-connect/assets/3678598/94f3e3c0-143d-40e7-9f14-69d1ea4f68f5)

![Screenshot 2024-03-01 at 6 46 11 AM](https://github.com/moraki-finance/revolut-connect/assets/3678598/a9c2a55d-3e7d-420c-8d9d-c9617438856f)

5) Exchange the code for your first time access token:

```rb
revolut_auth = Revolut::Auth.exchange(authorization_code: "{CODE YOU COPIED IN PREVIOUS STEP}")
```

6) This will return a `Revolut::Auth` object with the access token in it. It's highly recommended that you persist this information somewhere so that it can later be loaded without needing to go through this code exchange process again:

```rb
auth_to_persist = revolut_auth.to_json # Persist this somewhere (database, redis, etc.). Remember to encrypt it if you persist it.
```

And then, when you need to load the auth again:

```rb
Revolut::Auth.load(auth_to_persist)
```

You can also store this json in an environment variable and the gem will auto load it:

```
REVOLUT_AUTH_JSON={auth_to_persist}
```

:tada: You're all set to start using the API.

### Configuration

In rails applications, it's standard to provide an initializer (e.g `config/initializers/revolut.rb`) to load all the configuration settings of the gem. If you follow the previous step (First Time Authorization), you can do the following:

```rb
Revolut.configure do |config|
  # Your app client id. Typically stored in the environment variables as it's a sensitive secret.
  config.client_id = ENV["REVOLUT_CLIENT_ID"]

  # Your app private key. Typically stored in the environment variables as it's a sensitive secret.
  config.signing_key = ENV["REVOLUT_SIGNING_KEY"]

  # The URI that Revolut will redirect to upon a successful authorization.
  # Used to get the authorization code and exchange it for an access_token.
  config.authorize_redirect_uri = ENV["REVOLUT_AUTHORIZE_REDIRECT_URI"]

  # Optional: JWT issuer domain. Typically your app domain.
  # Default: example.com
  config.iss = ENV["REVOLUT_ISS"]

  # Optional: Timeout of the underlying faraday requests.
  # Default: 120
  config.request_timeout = 120

  # Optional: Set extra headers that will get attached to every revolut api request.
  # Useful for observability tools like Helicone: https://www.helicone.ai/
  # Default: {}
  config.global_headers = {
    "Helicone-Auth": "Bearer {HELICONE_API_KEY}"
    "helicone-stream-force-format" => "true",
  }

  # Optional: Set the environment to be production or sandbox.
  # Default: sandbox
  config.environment = ENV["REVOLUT_ENVIRONMENT"]
end
```

### Resources

*Coming soon*

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/moraki-finance/revolut-connect. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/moraki-finance/revolut-connect/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Revolut::Connect project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/revolut-connect/blob/main/CODE_OF_CONDUCT.md).
