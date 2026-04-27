# frozen_string_literal: true

module Admin
  module Infrastructure
    module Notifications
      class RailsNotifier < CustomerCore::Application::Interfaces::Notifier
        # @param event [Object]
        # @param context [Hash]
        # @return [void]
        def notify(event:, context: {})
          Rails.logger.info("Notifier event=#{event.class} context=#{context.inspect}")
        end
      end
    end
  end
end
