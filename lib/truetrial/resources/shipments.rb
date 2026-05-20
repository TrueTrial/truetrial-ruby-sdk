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

      # Manually confirms delivery of an order.
      #
      # For the edge case where the carrier lost the package update but the
      # consumer confirmed receipt. Records +delivery_source = manual+ and
      # starts the trial timer.
      #
      # @param order_id [String] the order ULID
      # @param data [Hash] params (delivered_at, reason, confirmed_by_email)
      # @return [Hash] the updated order resource
      def confirm_manually(order_id, data)
        @http.post("/orders/#{order_id}/confirm-delivery", body: data)
      end
    end
  end
end
