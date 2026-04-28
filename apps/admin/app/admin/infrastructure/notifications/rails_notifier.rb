# frozen_string_literal: true

module Admin
  module Infrastructure
    module Notifications
      class RailsNotifier < CustomerCore::Application::Interfaces::Notifier
        # @param event [Object]
        # @param context [Hash]
        # @return [CustomerCore::Application::Result]
        def notify(event:, context: {})
          Rails.logger.info("Notifier event=#{event.class} context=#{context.inspect}")
          CustomerCore::Application::Result.success
        rescue => e
          CustomerCore::Application::Result.failure(code: :notify_failed, message: e.message, cause: e)
        end
      end
    end
  end
end
