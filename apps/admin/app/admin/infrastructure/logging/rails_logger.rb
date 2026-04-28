# frozen_string_literal: true

module Admin
  module Infrastructure
    module Logging
      class RailsLogger < CustomerCore::Application::Interfaces::Logger
        # @param message [String]
        # @return [CustomerCore::Application::Result]
        def info(message)
          Rails.logger.info(message)
          CustomerCore::Application::Result.success
        end

        # @param message [String]
        # @return [CustomerCore::Application::Result]
        def error(message)
          Rails.logger.error(message)
          CustomerCore::Application::Result.success
        end
      end
    end
  end
end
