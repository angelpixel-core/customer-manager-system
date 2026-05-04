# frozen_string_literal: true

module CustomerCore
  module Application
    module Interfaces
      # Contract for integration notification adapters.
      # Global port convention: interfaces return Application::Result.
      class Notifier
        # @param event [Object]
        # @param context [Hash]
        # @return [CustomerCore::Application::Result]
        def notify(event:, context: {})
          raise NotImplementedError
        end
      end
    end
  end
end
