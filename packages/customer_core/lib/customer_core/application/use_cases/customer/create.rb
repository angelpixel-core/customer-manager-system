module CustomerCore
  module Application
    module UseCases
      module Customer
        # Creates a customer and publishes a domain event.
        class Create
          # @param repo [#create]
          # @param event_bus [#publish]
          def initialize(repo:, event_bus:)
            @repo = repo
            @event_bus = event_bus
          end

          # @param input [Hash]
          # @option input [String] :name
          # @option input [String] :email
          # @return [CustomerCore::Domain::Customer]
          def call(input)
            customer = Domain::Customer.new(**input)

            @repo.create(customer)

            @event_bus.publish(
              Events::Customer::Created.new(customer)
            )

            customer
          end
        end
      end
    end
  end
end
