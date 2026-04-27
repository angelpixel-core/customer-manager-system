module CustomerCore
  module Events
    module Customer
      # Domain event emitted after a customer is created.
      class Created
        # @return [CustomerCore::Domain::Customer]
        attr_reader :customer

        # @param customer [CustomerCore::Domain::Customer]
        def initialize(customer)
          @customer = customer
        end
      end
    end
  end
end
