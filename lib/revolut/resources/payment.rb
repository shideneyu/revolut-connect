require "forwardable"

module Revolut
  class Payment < Resource
    only :create

    class << self
      extend Forwardable

      # Delegate list, retrieve, and delete to the transactions resource
      def_delegators :transactions, :list, :retrieve, :delete

      def resource_name
        "pay"
      end

      def transactions
        Revolut::Transaction
      end
    end
  end
end
