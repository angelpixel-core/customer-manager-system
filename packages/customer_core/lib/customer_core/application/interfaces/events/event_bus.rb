# frozen_string_literal: true

module CustomerCore
  module Application
    module Interfaces
      module Events
        # Stable facade name for event publishing over a Publisher adapter.
        class EventBus < Publisher
          # @param publisher [CustomerCore::Application::Interfaces::Events::Publisher]
          def initialize(publisher:)
            @publisher = publisher
          end

          # @param event [Object]
          # @return [void]
          def publish(event)
            @publisher.publish(event)
          end
        end
      end
    end
  end
end
