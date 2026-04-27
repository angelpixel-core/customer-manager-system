module CustomerCore
  module Application
    module UseCases
      module Customer
        # Creates a customer and publishes a domain event.
        class Create
          # Class-level convenience entrypoint for callable usage.
          #
          # @param repo [CustomerCore::Application::Interfaces::Customer::Repository]
          # @param publisher [CustomerCore::Application::Interfaces::Events::Publisher]
          # @param logger [CustomerCore::Application::Interfaces::Logger, nil]
          # @param notifier [CustomerCore::Application::Interfaces::Notifier, nil]
          # @param dead_letter_store [CustomerCore::Application::Interfaces::Events::DeadLetterStore, nil]
          # @param input [Hash]
          # @return [CustomerCore::Domain::Customer]
          def self.call(repo:, input:, publisher:, logger: nil, notifier: nil, dead_letter_store: nil)
            new(
              repo: repo,
              publisher: publisher,
              logger: logger,
              notifier: notifier,
              dead_letter_store: dead_letter_store
            ).call(input)
          end

          # @param repo [CustomerCore::Application::Interfaces::Customer::Repository]
          # @param publisher [CustomerCore::Application::Interfaces::Events::Publisher]
          # @param logger [CustomerCore::Application::Interfaces::Logger, nil]
          # @param notifier [CustomerCore::Application::Interfaces::Notifier, nil]
          # @param dead_letter_store [CustomerCore::Application::Interfaces::Events::DeadLetterStore, nil]
          def initialize(repo:, publisher:, logger: nil, notifier: nil, dead_letter_store: nil)
            @repo = repo
            @publisher = publisher
            @logger = logger
            @notifier = notifier
            @dead_letter_store = dead_letter_store
          end

          # @param input [Hash]
          # @option input [String] :name
          # @option input [String] :email
          # @return [CustomerCore::Domain::Customer]
          def call(input)
            customer = Domain::Customer.new(**input)

            @repo.create(customer)

            event = Events::Customer::Created.new(customer)

            publish(event)
            notify(event)

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

          # @param event [Object]
          # @return [void]
          def notify(event)
            return unless @notifier

            @notifier.notify(event: event, context: {use_case: self.class.name})
          rescue StandardError => e
            @logger&.error("Failed to notify #{event.class}: #{e.class} - #{e.message}")
          end
        end
      end
    end
  end
end
