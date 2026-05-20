# frozen_string_literal: true

module TrueTrial
  module Resources
    # Provides access to temporal element API endpoints (trials, warranties, etc.).
    class Temporal
      def initialize(http_client)
        @http = http_client
      end

      # Retrieves the temporal element for an order.
      #
      # @param order_id [String] the order ULID
      # @return [Hash] the temporal element
      def get(order_id)
        @http.get("/orders/#{order_id}/temporal")
      end

      # Extends a temporal element duration.
      #
      # @param order_id [String] the order ULID
      # @param data [Hash] extension attributes (duration, unit, reason)
      # @return [Hash] the updated temporal element
      def extend(order_id, data)
        @http.post("/orders/#{order_id}/temporal/extend", body: data)
      end

      # Adjusts a temporal element (modify start/end dates).
      #
      # @param order_id [String] the order ULID
      # @param data [Hash] adjustment attributes
      # @return [Hash] the updated temporal element
      def adjust(order_id, data)
        @http.post("/orders/#{order_id}/temporal/adjust", body: data)
      end

      # Initiates a warranty or guarantee claim.
      #
      # @param order_id [String] the order ULID
      # @param data [Hash] claim attributes (reason, description)
      # @return [Hash] the created claim
      def claim(order_id, data)
        @http.post("/orders/#{order_id}/temporal/claim", body: data)
      end

      # Resolves a warranty or guarantee claim.
      #
      # @param order_id [String] the order ULID
      # @param data [Hash] resolution attributes (status, notes)
      # @return [Hash] the resolved claim
      def resolve_claim(order_id, data)
        @http.post("/orders/#{order_id}/temporal/resolve-claim", body: data)
      end
    end
  end
end
