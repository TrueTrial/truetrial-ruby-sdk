# frozen_string_literal: true

module TrueTrial
  module Resources
    # Provides access to order-related API endpoints.
    class Orders
      def initialize(http_client)
        @http = http_client
      end

      # Lists orders with optional filters.
      #
      # @param filters [Hash] optional query filters (status, page, per_page, etc.)
      # @return [Hash] paginated list of orders
      def list(filters = {})
        @http.get("/orders", params: filters)
      end

      # Creates a new order.
      #
      # @param data [Hash] order attributes
      # @return [Hash] the created order
      def create(data)
        @http.post("/orders", body: data)
      end

      # Retrieves a single order by ID.
      #
      # @param id [String] the order ULID
      # @return [Hash] the order
      def get(id)
        @http.get("/orders/#{id}")
      end

      # Retrieves the current status of an order.
      #
      # @param id [String] the order ULID
      # @return [Hash] the order status
      def status(id)
        @http.get("/orders/#{id}/status")
      end
    end
  end
end
