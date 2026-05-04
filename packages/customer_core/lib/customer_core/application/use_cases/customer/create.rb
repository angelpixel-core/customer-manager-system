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
          # @return [CustomerCore::Application::Result]
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
          # @return [CustomerCore::Application::Result]
          def call(input)
            customer = Domain::Customer.new(**input)
            persisted = @repo.create(customer)
            return persisted if persisted.failure?

            event = Events::Customer::Created.new(customer)

            published = publish(event)
            return published if published.failure?

            notify(event)

            Result.success(customer)
          rescue ArgumentError => e
            Result.failure(code: :invalid_input, message: e.message, cause: e)
          rescue StandardError => e
            Result.failure(code: :unexpected_error, message: e.message, cause: e)
          end

          private

          # @param event [Object]
          # @return [CustomerCore::Application::Result]
          def publish(event)
            publish_result = @publisher.publish(event)
            if publish_result.failure?
              error = publish_result.cause || StandardError.new(publish_result.message || "publish failed")
              @logger&.error("Failed to publish #{event.class}: #{error.class} - #{error.message}")
              @dead_letter_store&.record(
                event: event,
                error: error,
                context: {use_case: self.class.name, code: publish_result.code}
              )

              return publish_result
            end

            Result.success
          rescue StandardError => e
            @logger&.error("Failed to publish #{event.class}: #{e.class} - #{e.message}")
            @dead_letter_store&.record(event: event, error: e, context: {use_case: self.class.name})

            Result.failure(code: :publish_failed, message: e.message, cause: e)
          end

          # @param event [Object]
          # @return [CustomerCore::Application::Result]
          def notify(event)
            return Result.success unless @notifier

            notify_result = @notifier.notify(event: event, context: {use_case: self.class.name})
            return notify_result if notify_result.failure?

            Result.success
          rescue StandardError => e
            @logger&.error("Failed to notify #{event.class}: #{e.class} - #{e.message}")
            Result.failure(code: :notify_failed, message: e.message, cause: e)
          end
        end
      end
    end
  end
end
