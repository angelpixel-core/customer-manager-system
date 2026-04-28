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
        # @return [CustomerCore::Application::Result]
        def call(platform_event)
          payload = @serializer.serialize(platform_event)
          return CustomerCore::Application::Result.success unless payload

          if @webhook_url.to_s.strip.empty?
            @logger.info("N8n forwarder skipped: webhook URL not configured")
            return CustomerCore::Application::Result.success(metadata: {skipped: true})
          end

          response = @client.post_json(url: @webhook_url, payload: payload)
          return CustomerCore::Application::Result.success if response.is_a?(Net::HTTPSuccess)

          message = "n8n forward failed: HTTP #{response.code}"
          @logger.error("N8n forwarder failed for #{platform_event.name}: #{message}")

          CustomerCore::Application::Result.failure(
            code: :n8n_http_error,
            message: message
          )
        rescue => e
          @logger.error("N8n forwarder failed for #{platform_event.name}: #{e.class} - #{e.message}")
          CustomerCore::Application::Result.failure(code: :n8n_forward_failed, message: e.message, cause: e)
        end
      end
    end
  end
end
