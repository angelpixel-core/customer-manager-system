module Admin
  module Infrastructure
    module Repositories
      module ActiveRecord
        class CustomerRepository
          def create(customer)
            ::Customer::Record.create!(
              name: customer.name,
              email: customer.email
            )
          end
        end
      end
    end
  end
end
