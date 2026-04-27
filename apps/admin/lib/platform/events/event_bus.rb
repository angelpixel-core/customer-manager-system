# frozen_string_literal: true

module Platform
  module Events
    # Minimal platform event bus that dispatches events via a registry.
    class EventBus < CustomerCore::Application::Interfaces::Events::Publisher
      # @param registry [Platform::Events::Registry]
      def initialize(registry:)
        @registry = registry
      end

      # @param event [Object]
      # @return [void]
      def publish(event)
        platform_event = Event.new(raw_event: event)

        @registry.handlers_for(event).each do |handler|
          handler.call(platform_event)
        end
      end
    end
  end
end
