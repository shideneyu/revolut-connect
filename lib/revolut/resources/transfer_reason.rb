module Revolut
  class TransferReason < Resource
    only :list

    def self.resources_name
      "transfer-reasons"
    end
  end
end
