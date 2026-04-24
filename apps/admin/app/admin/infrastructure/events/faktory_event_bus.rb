module Admin
  module Infrastructure
    module Events
      class FaktoryEventBus
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
