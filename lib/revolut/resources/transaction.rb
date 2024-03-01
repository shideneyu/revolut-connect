module Revolut
  class Transaction < Resource
    only :list, :retrieve, :delete

    def self.resource_name
      "transaction"
    end

    def self.resources_name
      "transactions"
    end
  end
end
