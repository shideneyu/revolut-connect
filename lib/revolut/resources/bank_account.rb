module Revolut
  # Reference: https://developer.revolut.com/docs/business/counterparties
  class BankAccount < Resource
    shallow # do not allow any resource operations on this resource
  end
end
