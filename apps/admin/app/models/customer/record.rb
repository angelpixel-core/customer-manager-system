# == Schema Information
#
# Table name: customer_records
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  email      :string           not null
#  name       :string           not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_customer_records_on_email  (email) UNIQUE
#

module Customer
  # ActiveRecord persistence model for customers in admin app.
  class Record < ApplicationRecord
    self.table_name = "customer_records"

    # @param _auth_object [Object, nil]
    # @return [Array<String>]
    def self.ransackable_attributes(_auth_object = nil)
      %w[created_at email id name updated_at]
    end

    # @param _auth_object [Object, nil]
    # @return [Array<String>]
    def self.ransackable_associations(_auth_object = nil)
      []
    end
  end
end
