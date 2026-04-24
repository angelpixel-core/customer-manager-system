module CustomerCore
  module Events
    module Customer
      class Created
        attr_reader :customer

        def initialize(customer)
          @customer = customer
        end
      end
    end
  end
end
