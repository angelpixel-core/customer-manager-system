# frozen_string_literal: true

module Platform
  module Events
    class Metrics
      # @param event_name [String]
      # @param handler [String]
      # @param attempt [Integer]
      # @param max_attempts [Integer]
      # @param error_class [String]
      # @return [void]
      def retry(event_name:, handler:, attempt:, max_attempts:, error_class:)
        ActiveSupport::Notifications.instrument(
          "platform.events.retry",
          {
            event_name: event_name,
            handler: handler,
            attempt: attempt,
            max_attempts: max_attempts,
            error_class: error_class
          }
        )
      end

      # @param event_name [String]
      # @param handler [String]
      # @param attempts [Integer]
      # @param error_class [String]
      # @return [void]
      def failure(event_name:, handler:, attempts:, error_class:)
        ActiveSupport::Notifications.instrument(
          "platform.events.failure",
          {
            event_name: event_name,
            handler: handler,
            attempts: attempts,
            error_class: error_class
          }
        )
      end

      # @param event_name [String]
      # @param handler [String]
      # @param error_class [String]
      # @return [void]
      def dead_letter_recorded(event_name:, handler:, error_class:)
        ActiveSupport::Notifications.instrument(
          "platform.events.dead_letter_recorded",
          {
            event_name: event_name,
            handler: handler,
            error_class: error_class
          }
        )
      end
    end
  end
end
