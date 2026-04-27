# frozen_string_literal: true

module Admin
  module Infrastructure
    module Logging
      class RailsLogger < CustomerCore::Application::Interfaces::Logger
        # @param message [String]
        # @return [void]
        def info(message)
          Rails.logger.info(message)
        end

        # @param message [String]
        # @return [void]
        def error(message)
          Rails.logger.error(message)
        end
      end
    end
  end
end
