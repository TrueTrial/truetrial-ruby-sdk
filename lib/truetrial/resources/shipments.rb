# frozen_string_literal: true

module TrueTrial
  module Resources
    # Provides access to shipment-related API endpoints.
    class Shipments
      def initialize(http_client)
        @http = http_client
      end

      # Creates a shipment for an order.
      #
      # @param order_id [String] the order ULID
      # @param data [Hash] shipment attributes (carrier, tracking_number, etc.)
      # @return [Hash] the created shipment
      def create(order_id, data)
        @http.post("/orders/#{order_id}/shipments", body: data)
      end

      # Lists all shipments for an order.
      #
      # @param order_id [String] the order ULID
      # @return [Hash] list of shipments
      def list(order_id)
        @http.get("/orders/#{order_id}/shipments")
      end
    end
  end
end
