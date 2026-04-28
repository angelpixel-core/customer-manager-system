# frozen_string_literal: true

require "net/http"
require "uri"
require "json"

module Platform
  module Integrations
    module N8n
      class Client
        # @param open_timeout [Numeric]
        # @param read_timeout [Numeric]
        def initialize(open_timeout: 2, read_timeout: 2)
          @open_timeout = open_timeout
          @read_timeout = read_timeout
        end

        # @param url [String]
        # @param payload [Hash]
        # @return [Net::HTTPResponse]
        def post_json(url:, payload:)
          uri = URI.parse(url)
          request = Net::HTTP::Post.new(uri)
          request["Content-Type"] = "application/json"
          request.body = JSON.generate(payload)

          Net::HTTP.start(
            uri.host,
            uri.port,
            use_ssl: uri.scheme == "https",
            open_timeout: @open_timeout,
            read_timeout: @read_timeout
          ) do |http|
            http.request(request)
          end
        end
      end
    end
  end
end
