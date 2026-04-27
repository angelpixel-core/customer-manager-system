# frozen_string_literal: true

module CustomerCore
  module Application
    module Interfaces
      module Events
        # Contract for event publishing adapters.
        class Publisher
          # @param event [Object]
          # @return [void]
          def publish(event)
            raise NotImplementedError
          end
        end
      end
    end
  end
end
