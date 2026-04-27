# frozen_string_literal: true

module Platform
  module Events
    # Maps domain event classes to handler callables.
    class Registry
      def initialize
        @handlers_by_event = Hash.new { |hash, key| hash[key] = [] }
      end

      # @param event_class [Class]
      # @param handler [#call, nil]
      # @yield [event]
      # @return [void]
      def register(event_class, handler = nil, &block)
        callable = handler || block
        raise ArgumentError, "handler must respond to #call" unless callable&.respond_to?(:call)

        @handlers_by_event[event_class] << callable
      end

      # @param event [Object]
      # @return [Array<#call>]
      def handlers_for(event)
        @handlers_by_event.fetch(event.class, [])
      end
    end
  end
end
