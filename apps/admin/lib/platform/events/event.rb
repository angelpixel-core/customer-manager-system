# frozen_string_literal: true

module Platform
  module Events
    # Normalized event envelope for platform-level handlers.
    class Event
      attr_reader :raw_event, :name, :occurred_at, :context

      # @param raw_event [Object]
      # @param occurred_at [Time]
      # @param context [Hash]
      def initialize(raw_event:, occurred_at: Time.current, context: {})
        @raw_event = raw_event
        @name = raw_event.class.name
        @occurred_at = occurred_at
        @context = context
      end
    end
  end
end
