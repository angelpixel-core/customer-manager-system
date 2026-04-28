# frozen_string_literal: true

module Platform
  module Events
    class RetryHandler
      class ExhaustedRetriesError < StandardError
        attr_reader :error, :attempts

        # @param error [StandardError]
        # @param attempts [Integer]
        def initialize(error:, attempts:)
          @error = error
          @attempts = attempts
          super("Retries exhausted after #{attempts} attempts: #{error.class} - #{error.message}")
        end
      end

      # @param max_attempts [Integer]
      # @param base_delay_seconds [Numeric]
      def initialize(max_attempts: 3, base_delay_seconds: 0)
        @max_attempts = max_attempts
        @base_delay_seconds = base_delay_seconds
      end

      # @param on_retry [#call, nil]
      # @yieldparam attempt [Integer]
      # @return [Object]
      def call(on_retry: nil)
        attempt = 0

        begin
          attempt += 1
          yield(attempt)
        rescue => e
          if attempt < @max_attempts
            on_retry&.call(error: e, attempt: attempt, max_attempts: @max_attempts)
            sleep(@base_delay_seconds) if @base_delay_seconds.positive?
            retry
          end

          raise ExhaustedRetriesError.new(error: e, attempts: attempt)
        end
      end
    end
  end
end
