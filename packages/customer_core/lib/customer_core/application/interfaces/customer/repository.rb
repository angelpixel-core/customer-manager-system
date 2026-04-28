# frozen_string_literal: true

module CustomerCore
  module Application
    module Interfaces
      module Customer
        # Global port convention: interfaces return Application::Result
        # and avoid raising for expected adapter failures.
        class Repository
          # @param customer [CustomerCore::Domain::Customer]
          # @return [CustomerCore::Application::Result]
          def create(customer)
            raise NotImplementedError
          end
        end
      end
    end
  end
end
