# frozen_string_literal: true

module Admin
  module Infrastructure
    module Events
      # Faktory-backed event bus adapter.
      class FaktoryEventBus < CustomerCore::Application::Interfaces::Events::Publisher
        # @param event [Object]
        # @return [void]
        def publish(event)
          case event
          when CustomerCore::Events::Customer::Created
            return if Rails.env.test?

            Admin::Infrastructure::SendWelcomeEmailWorker.perform_async(event.customer.email)
          end
        end
      end
    end
  end
end
