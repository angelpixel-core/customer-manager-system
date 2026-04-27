# frozen_string_literal: true

module Admin
  module Infrastructure
    module Events
      class RailsDeadLetterStore < CustomerCore::Application::Interfaces::Events::DeadLetterStore
        # @param event [Object]
        # @param error [StandardError]
        # @param context [Hash]
        # @return [void]
        def record(event:, error:, context: {})
          Rails.logger.error(
            "Dead letter event=#{event.class} error=#{error.class}: #{error.message} context=#{context.inspect}"
          )
        end
      end
    end
  end
end
