# frozen_string_literal: true

module CustomerCore
  module Application
    module Interfaces
      module Events
        # Stable facade contract for event publishing in core.
        #
        # This facade intentionally delegates to a publisher adapter and does
        # not orchestrate retries, registry, or persistent DLQ at core level.
        class EventBus < Publisher
          # @param publisher [CustomerCore::Application::Interfaces::Events::Publisher]
          def initialize(publisher:)
            @publisher = publisher
          end

          # @param event [Object]
          # @return [CustomerCore::Application::Result]
          def publish(event)
            @publisher.publish(event)
          end
        end
      end
    end
  end
end
