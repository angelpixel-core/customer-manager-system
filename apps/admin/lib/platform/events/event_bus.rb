# frozen_string_literal: true

module Platform
  module Events
    # Minimal platform event bus that dispatches events via a registry.
    class EventBus < CustomerCore::Application::Interfaces::Events::Publisher
      # @param registry [Platform::Events::Registry]
      # @param retry_handler [Platform::Events::RetryHandler]
      # @param dead_letter_queue [Platform::Events::DeadLetterQueue]
      # @param metrics [Platform::Events::Metrics]
      def initialize(
        registry:,
        retry_handler: RetryHandler.new,
        dead_letter_queue: DeadLetterQueue.new,
        metrics: Metrics.new
      )
        @registry = registry
        @retry_handler = retry_handler
        @dead_letter_queue = dead_letter_queue
        @metrics = metrics
      end

      # @param event [Object]
      # @return [void]
      def publish(event)
        platform_event = Event.new(raw_event: event)

        @registry.handlers_for(event).each do |handler|
          publish_to_handler(handler: handler, platform_event: platform_event)
        end
      end

      private

      # @param handler [#call]
      # @param platform_event [Platform::Events::Event]
      # @return [void]
      def publish_to_handler(handler:, platform_event:)
        @retry_handler.call(
          on_retry: lambda do |retry_data|
            @metrics.retry(
              event_name: platform_event.name,
              handler: handler_name(handler),
              attempt: retry_data[:attempt],
              max_attempts: retry_data[:max_attempts],
              error_class: retry_data[:error].class.name
            )
          end
        ) do
          handler.call(platform_event)
        end
      rescue RetryHandler::ExhaustedRetriesError => exhausted_error
        @metrics.failure(
          event_name: platform_event.name,
          handler: handler_name(handler),
          attempts: exhausted_error.attempts,
          error_class: exhausted_error.error.class.name
        )

        @dead_letter_queue.push(
          event: platform_event,
          error: exhausted_error.error,
          metadata: {
            handler: handler_name(handler),
            attempts: exhausted_error.attempts
          }
        )

        @metrics.dead_letter_recorded(
          event_name: platform_event.name,
          handler: handler_name(handler),
          error_class: exhausted_error.error.class.name
        )
      end

      # @param handler [#call]
      # @return [String]
      def handler_name(handler)
        return "#{handler.receiver.class}##{handler.name}" if handler.respond_to?(:receiver)

        handler.class.name || "AnonymousHandler"
      end
    end
  end
end
