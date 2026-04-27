# frozen_string_literal: true

module CustomerCore
  module Application
    module Interfaces
      module Customer
        class Repository
          def create(customer)
            raise NotImplementedError
          end
        end
      end
    end
  end
end

