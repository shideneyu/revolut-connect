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

### Setup

You'll need to set the some configuration settings for this connector to work:.

```rb
Revolut.configure do |config|

  # Follow the steps in this tutorial:
  # https://developer.revolut.com/docs/guides/manage-accounts/get-started/make-your-first-api-request
  # to get the below configuration settings values.

  # Your app client id
  config.client_id = "qtZnay...."

  # Your app private key
  config.signing_key = "-----BEGIN PRIVATE KEY-----...."

  # Issuer domain. Typically your app domain.
  config.iss = "example.com"

  # The URI that Revolut will redirect to upon a successful authorization.
  # Used to get the authorization code and exchange it for an access_token.
  config.authorize_redirect_uri = "https://example.com"

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
  config.environment = :sandbox
end
```

### Flow

*Coming soon*

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/revolut-connect. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/revolut-connect/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Revolut::Connect project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/revolut-connect/blob/main/CODE_OF_CONDUCT.md).
