module CustomerCore
  module Application
    module UseCases
      module Customer
        # Creates a customer and publishes a domain event.
        class Create
          # Class-level convenience entrypoint for callable usage.
          #
          # @param repo [CustomerCore::Application::Interfaces::Customer::Repository]
          # @param publisher [CustomerCore::Application::Interfaces::Events::Publisher, nil]
          # @param event_bus [CustomerCore::Application::Interfaces::Events::Publisher, nil]
          # @param logger [CustomerCore::Application::Interfaces::Logger, nil]
          # @param dead_letter_store [CustomerCore::Application::Interfaces::Events::DeadLetterStore, nil]
          # @param input [Hash]
          # @return [CustomerCore::Domain::Customer]
          def self.call(repo:, input:, publisher: nil, event_bus: nil, logger: nil, dead_letter_store: nil)
            new(
              repo: repo,
              publisher: publisher,
              event_bus: event_bus,
              logger: logger,
              dead_letter_store: dead_letter_store
            ).call(input)
          end

          # @param repo [CustomerCore::Application::Interfaces::Customer::Repository]
          # @param publisher [CustomerCore::Application::Interfaces::Events::Publisher, nil]
          # @param event_bus [CustomerCore::Application::Interfaces::Events::Publisher, nil]
          # @param logger [CustomerCore::Application::Interfaces::Logger, nil]
          # @param dead_letter_store [CustomerCore::Application::Interfaces::Events::DeadLetterStore, nil]
          def initialize(repo:, publisher: nil, event_bus: nil, logger: nil, dead_letter_store: nil)
            @repo = repo
            @publisher = publisher || event_bus
            @logger = logger
            @dead_letter_store = dead_letter_store

            raise ArgumentError, "publisher required" unless @publisher
          end

          # @param input [Hash]
          # @option input [String] :name
          # @option input [String] :email
          # @return [CustomerCore::Domain::Customer]
          def call(input)
            customer = Domain::Customer.new(**input)

            @repo.create(customer)

            publish(Events::Customer::Created.new(customer))

            customer
          end

          private

          # @param event [Object]
          # @return [void]
          def publish(event)
            @publisher.publish(event)
          rescue StandardError => e
            @logger&.error("Failed to publish #{event.class}: #{e.class} - #{e.message}")
            @dead_letter_store&.record(event: event, error: e, context: {use_case: self.class.name})
            raise
          end
        end
      end
    end
  end
end
