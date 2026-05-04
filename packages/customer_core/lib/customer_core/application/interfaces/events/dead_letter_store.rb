# frozen_string_literal: true

module CustomerCore
  module Application
    module Interfaces
      module Events
        # Contract for storing failed events (dead-letter).
        # Global port convention: interfaces return Application::Result.
        class DeadLetterStore
          # @param event [Object]
          # @param error [StandardError]
          # @param context [Hash]
          # @return [CustomerCore::Application::Result]
          def record(event:, error:, context: {})
            raise NotImplementedError
          end
        end
      end
    end
  end
end
