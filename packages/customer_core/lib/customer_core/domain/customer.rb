# frozen_string_literal: true

module CustomerCore
  module Domain
    class Customer
      attr_reader :name, :email

      def initialize(name:, email:)
        raise ArgumentError, "email required" if email.nil?
        @name = name
        @email = email
      end
    end
  end
end
