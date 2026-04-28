# frozen_string_literal: true

module CustomerCore
  module Application
    module Interfaces
      # Contract for logging adapters used in application actions.
      # Global port convention: interfaces return Application::Result.
      class Logger
        # @param message [String]
        # @return [CustomerCore::Application::Result]
        def info(message)
          raise NotImplementedError
        end

        # @param message [String]
        # @return [CustomerCore::Application::Result]
        def error(message)
          raise NotImplementedError
        end
      end
    end
  end
end
