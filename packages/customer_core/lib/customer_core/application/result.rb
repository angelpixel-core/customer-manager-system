# frozen_string_literal: true

module CustomerCore
  module Application
    class Result
      attr_reader :value, :error, :code, :metadata

      # @param value [Object]
      # @param metadata [Hash]
      # @return [CustomerCore::Application::Result]
      def self.success(value = nil, metadata: {})
        new(status: :success, value: value, metadata: metadata)
      end

      # @param code [Symbol, String]
      # @param message [String]
      # @param cause [StandardError, nil]
      # @param metadata [Hash]
      # @return [CustomerCore::Application::Result]
      def self.failure(code:, message:, cause: nil, metadata: {})
        new(status: :failure, code: code, error: {message: message, cause: cause}, metadata: metadata)
      end

      # @param status [Symbol]
      # @param value [Object]
      # @param code [Symbol, String, nil]
      # @param error [Hash, nil]
      # @param metadata [Hash]
      def initialize(status:, value: nil, code: nil, error: nil, metadata: {})
        @status = status
        @value = value
        @code = code
        @error = error
        @metadata = metadata
      end

      # @return [Boolean]
      def success?
        @status == :success
      end

      # @return [Boolean]
      def failure?
        @status == :failure
      end

      # @return [String, nil]
      def message
        @error&.fetch(:message, nil)
      end

      # @return [StandardError, nil]
      def cause
        @error&.fetch(:cause, nil)
      end
    end
  end
end
