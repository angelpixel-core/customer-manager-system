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
      # @return [CustomerCore::Application::Result]
      def publish(event)
        platform_event = Event.new(raw_event: event)

        @registry.handlers_for(event).each do |handler|
          handler_result = publish_to_handler(handler: handler, platform_event: platform_event)
          return handler_result if handler_result.failure?
        end

        CustomerCore::Application::Result.success
      end

      private

      # @param handler [#call]
      # @param platform_event [Platform::Events::Event]
      # @return [CustomerCore::Application::Result]
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
          result = handler.call(platform_event)
          normalize_handler_result(result)
        end
        CustomerCore::Application::Result.success
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

        CustomerCore::Application::Result.failure(
          code: :handler_exhausted,
          message: exhausted_error.message,
          cause: exhausted_error.error,
          metadata: {handler: handler_name(handler), attempts: exhausted_error.attempts}
        )
      end

      # @param result [Object]
      # @return [void]
      def normalize_handler_result(result)
        return if result.nil?
        return if !result.respond_to?(:failure?)

        raise StandardError, result.message if result.failure?
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
