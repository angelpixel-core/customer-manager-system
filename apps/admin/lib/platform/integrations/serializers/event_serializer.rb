# frozen_string_literal: true

module Platform
  module Integrations
    module Serializers
      class EventSerializer
        SERIALIZERS = {
          CustomerCore::Events::Customer::Created => CustomerCreated
        }.freeze

        # @param platform_event [Platform::Events::Event]
        # @return [Hash, nil]
        def serialize(platform_event)
          serializer_class = SERIALIZERS[platform_event.raw_event.class]
          return unless serializer_class

          serializer_class.new.serialize(platform_event)
        end
      end
    end
  end
end
