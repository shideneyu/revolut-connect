module Revolut
  # Reference: https://developer.revolut.com/docs/business/counterparties
  class Counterparty < Resource
    not_allowed_to :update
    coerce_with accounts: Revolut::BankAccount

    def self.resource_name
      "counterparty"
    end

    def self.resources_name
      "counterparties"
    end
  end
end
