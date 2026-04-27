# frozen_string_literal: true

module CustomerCore
  module Application
    module Interfaces
      # Contract for integration notification adapters.
      class Notifier
        # @param event [Object]
        # @param context [Hash]
        # @return [void]
        def notify(event:, context: {})
          raise NotImplementedError
        end
      end
    end
  end
end
