# frozen_string_literal: true

module Platform
  module Events
    class DeadLetterQueue
      # @param event [Platform::Events::Event, Object]
      # @param error [StandardError]
      # @param metadata [Hash]
      # @return [Platform::Events::DeadLetterRecord]
      def push(event:, error:, metadata: {})
        envelope = event.is_a?(Platform::Events::Event) ? event : Event.new(raw_event: event)

        Platform::Events::DeadLetterRecord.create!(
          event_name: envelope.name,
          event_payload: serialize_raw_event(envelope.raw_event),
          context: envelope.context,
          metadata: metadata,
          error_class: error.class.name,
          error_message: error.message,
          failed_at: Time.current,
          occurred_at: envelope.occurred_at
        )
      end

      private

      # @param raw_event [Object]
      # @return [Hash]
      def serialize_raw_event(raw_event)
        return raw_event.to_h if raw_event.respond_to?(:to_h)

        if raw_event.respond_to?(:customer)
          customer = raw_event.customer
          return {
            customer: {
              name: customer.respond_to?(:name) ? customer.name : nil,
              email: customer.respond_to?(:email) ? customer.email : nil
            }
          }
        end

        {inspect: raw_event.inspect}
      end
    end
  end
end
