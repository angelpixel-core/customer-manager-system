# frozen_string_literal: true

module CustomerCore
  module Application
    module Interfaces
      module Events
        # Contract for event publishing adapters.
        # Global port convention: interfaces return Application::Result.
        class Publisher
          # @param event [Object]
          # @return [CustomerCore::Application::Result]
          def publish(event)
            raise NotImplementedError
          end
        end
      end
    end
  end
end
