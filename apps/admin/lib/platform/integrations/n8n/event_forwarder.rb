# frozen_string_literal: true

module Platform
  module Integrations
    module N8n
      class EventForwarder
        # @param webhook_url [String, nil]
        # @param serializer [Platform::Integrations::Serializers::EventSerializer]
        # @param client [Platform::Integrations::N8n::Client]
        # @param logger [#info, #error]
        def initialize(
          webhook_url: ENV["N8N_WEBHOOK_URL"],
          serializer: Serializers::EventSerializer.new,
          client: Client.new,
          logger: Rails.logger
        )
          @webhook_url = webhook_url
          @serializer = serializer
          @client = client
          @logger = logger
        end

        # @param platform_event [Platform::Events::Event]
        # @return [void]
        def call(platform_event)
          payload = @serializer.serialize(platform_event)
          return unless payload

          if @webhook_url.to_s.strip.empty?
            @logger.info("N8n forwarder skipped: webhook URL not configured")
            return
          end

          response = @client.post_json(url: @webhook_url, payload: payload)
          return if response.is_a?(Net::HTTPSuccess)

          raise StandardError, "n8n forward failed: HTTP #{response.code}"
        rescue StandardError => e
          @logger.error("N8n forwarder failed for #{platform_event.name}: #{e.class} - #{e.message}")
          raise
        end
      end
    end
  end
end
