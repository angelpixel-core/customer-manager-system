# frozen_string_literal: true

module Platform
  module Integrations
    module Serializers
      class CustomerCreated
        # @param platform_event [Platform::Events::Event]
        # @return [Hash]
        def serialize(platform_event)
          domain_event = platform_event.raw_event

          {
            event_name: "customer.created",
            occurred_at: platform_event.occurred_at.iso8601,
            source: "customers_manager_system",
            customer: {
              name: domain_event.customer.name,
              email: domain_event.customer.email
            },
            context: platform_event.context
          }
        end
      end
    end
  end
end
