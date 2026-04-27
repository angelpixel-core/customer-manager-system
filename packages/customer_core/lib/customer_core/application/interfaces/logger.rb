# frozen_string_literal: true

module CustomerCore
  module Application
    module Interfaces
      # Contract for logging adapters used in application actions.
      class Logger
        # @param message [String]
        # @return [void]
        def info(message)
          raise NotImplementedError
        end

        # @param message [String]
        # @return [void]
        def error(message)
          raise NotImplementedError
        end
      end
    end
  end
end
