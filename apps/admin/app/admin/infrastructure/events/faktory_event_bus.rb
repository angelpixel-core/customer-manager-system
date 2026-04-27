# frozen_string_literal: true

module Admin
  module Infrastructure
    module Events
      # Faktory-backed event bus adapter.
      class FaktoryEventBus < CustomerCore::Application::Interfaces::Events::Publisher
        # @param event_bus [Platform::Events::EventBus, nil]
        # @param registry [Platform::Events::Registry, nil]
        # @param n8n_forwarder [#call, nil]
        def initialize(event_bus: nil, registry: nil, n8n_forwarder: nil)
          @registry = registry || build_registry(n8n_forwarder: n8n_forwarder)
          @event_bus = event_bus || Platform::Events::EventBus.new(registry: @registry)
        end

        # @param event [Object]
        # @return [void]
        def publish(event)
          @event_bus.publish(event)
        end

        private

        # @return [Platform::Events::Registry]
        def build_registry(n8n_forwarder: nil)
          Platform::Events::Registry.new.tap do |registry|
            registry.register(CustomerCore::Events::Customer::Created, method(:handle_customer_created))
            registry.register(CustomerCore::Events::Customer::Created, n8n_forwarder || default_n8n_forwarder)
          end
        end

        # @return [Platform::Integrations::N8n::EventForwarder]
        def default_n8n_forwarder
          Platform::Integrations::N8n::EventForwarder.new
        end

        # @param platform_event [Platform::Events::Event]
        # @return [void]
        def handle_customer_created(platform_event)
          return if Rails.env.test?

          Admin::Infrastructure::SendWelcomeEmailWorker.perform_async(platform_event.raw_event.customer.email)
        end
      end
    end
  end
end
