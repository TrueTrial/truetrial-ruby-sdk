# frozen_string_literal: true

module TrueTrial
  module Resources
    # Provides access to cancellation-related API endpoints.
    class Cancellations
      def initialize(http_client)
        @http = http_client
      end

      # Creates a cancellation for an order.
      #
      # @param order_id [String] the order ULID
      # @param data [Hash] cancellation attributes (reason, etc.)
      # @return [Hash] the created cancellation
      def create(order_id, data)
        @http.post("/orders/#{order_id}/cancellations", body: data)
      end

      # Retrieves the cancellation for an order.
      #
      # @param order_id [String] the order ULID
      # @return [Hash] the cancellation
      def get(order_id)
        @http.get("/orders/#{order_id}/cancellations")
      end
    end
  end
end
