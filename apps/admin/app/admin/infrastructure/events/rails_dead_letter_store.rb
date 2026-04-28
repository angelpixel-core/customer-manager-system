# frozen_string_literal: true

module Admin
  module Infrastructure
    module Events
      class RailsDeadLetterStore < CustomerCore::Application::Interfaces::Events::DeadLetterStore
        # @param dead_letter_queue [Platform::Events::DeadLetterQueue, nil]
        # @param metrics [Platform::Events::Metrics, nil]
        def initialize(dead_letter_queue: nil, metrics: nil)
          @dead_letter_queue = dead_letter_queue || Platform::Events::DeadLetterQueue.new
          @metrics = metrics || Platform::Events::Metrics.new
        end

        # @param event [Object]
        # @param error [StandardError]
        # @param context [Hash]
        # @return [CustomerCore::Application::Result]
        def record(event:, error:, context: {})
          @dead_letter_queue.push(event: event, error: error, metadata: {source: "rails_dead_letter_store"})

          @metrics.dead_letter_recorded(
            event_name: event.class.name,
            handler: self.class.name,
            error_class: error.class.name
          )

          Rails.logger.error(
            "Dead letter persisted event=#{event.class} error=#{error.class}: #{error.message} context=#{context.inspect}"
          )

          CustomerCore::Application::Result.success
        rescue StandardError => e
          CustomerCore::Application::Result.failure(code: :dead_letter_persist_failed, message: e.message, cause: e)
        end
      end
    end
  end
end
