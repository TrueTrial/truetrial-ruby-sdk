# frozen_string_literal: true

module TrueTrial
  module Resources
    # Provides access to webhook subscription management endpoints.
    class Webhooks
      def initialize(http_client)
        @http = http_client
      end

      # Lists all webhook subscriptions.
      #
      # @return [Hash] list of webhook subscriptions
      def list
        @http.get("/webhooks")
      end

      # Creates a new webhook subscription.
      #
      # @param data [Hash] webhook attributes (url, events, secret)
      # @return [Hash] the created webhook subscription
      def create(data)
        @http.post("/webhooks", body: data)
      end

      # Deletes a webhook subscription.
      #
      # @param id [String] the webhook subscription ULID
      # @return [Hash] deletion confirmation
      def delete(id)
        @http.delete("/webhooks/#{id}")
      end
    end
  end
end
