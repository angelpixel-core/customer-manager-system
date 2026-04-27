# frozen_string_literal: true

module CustomerCore
  module Domain
    # Customer aggregate root used by application use cases.
    class Customer
      # @return [String]
      attr_reader :name, :email

      # @param name [String]
      # @param email [String]
      # @raise [ArgumentError] when email is nil
      def initialize(name:, email:)
        raise ArgumentError, "email required" if email.nil?
        @name = name
        @email = email
      end
    end
  end
end
