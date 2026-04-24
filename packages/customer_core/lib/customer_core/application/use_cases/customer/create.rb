module CustomerCore
  module Application
    module UseCases
      module Customer
        class Create
          def initialize(repo:, event_bus:)
            @repo = repo
            @event_bus = event_bus
          end

          def call(input)
            customer = Domain::Customer.new(**input)

            @repo.create(customer)

            @event_bus.publish(
              Events::CustomerCreated.new(customer)
            )

            customer
          end
        end
      end
    end
  end
end
