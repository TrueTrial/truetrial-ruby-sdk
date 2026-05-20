# frozen_string_literal: true

module TrueTrial
  module Resources
    # Provides access to digital delivery confirmation endpoints.
    class DigitalDelivery
      def initialize(http_client)
        @http = http_client
      end

      # Confirms digital delivery for an order.
      #
      # @param order_id [String] the order ULID
      # @param data [Hash] digital delivery confirmation attributes
      # @return [Hash] the delivery confirmation result
      def confirm(order_id, data)
        @http.post("/orders/#{order_id}/digital-delivery", body: data)
      end
    end
  end
end
