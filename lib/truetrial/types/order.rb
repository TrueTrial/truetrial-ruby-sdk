# frozen_string_literal: true

module TrueTrial
  module Types
    # Represents an order returned from the TrueTrial API.
    class Order
      attr_reader :id, :tenant_id, :consumer_id, :external_order_id, :status,
                  :product_type, :total_cents, :currency, :metadata,
                  :created_at, :updated_at

      def initialize(attributes = {})
        @id = attributes["id"]
        @tenant_id = attributes["tenant_id"]
        @consumer_id = attributes["consumer_id"]
        @external_order_id = attributes["external_order_id"]
        @status = attributes["status"]
        @product_type = attributes["product_type"]
        @total_cents = attributes["total_cents"]
        @currency = attributes["currency"]
        @metadata = attributes["metadata"]
        @created_at = attributes["created_at"]
        @updated_at = attributes["updated_at"]
      end

      # Builds an Order from an API response hash.
      #
      # @param hash [Hash] raw API response data
      # @return [Order]
      def self.from_hash(hash)
        new(hash)
      end
    end
  end
end
