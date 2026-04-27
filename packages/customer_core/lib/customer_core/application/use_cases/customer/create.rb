module CustomerCore
  module Application
    module UseCases
      module Customer
        # Creates a customer and publishes a domain event.
        class Create
          # Class-level convenience entrypoint for callable usage.
          #
          # @param repo [#create]
          # @param event_bus [#publish]
          # @param input [Hash]
          # @return [CustomerCore::Domain::Customer]
          def self.call(repo:, event_bus:, input:)
            new(repo: repo, event_bus: event_bus).call(input)
          end

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
