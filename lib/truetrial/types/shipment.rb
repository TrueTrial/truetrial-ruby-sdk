# frozen_string_literal: true

module TrueTrial
  module Types
    # Represents a shipment returned from the TrueTrial API.
    class Shipment
      attr_reader :id, :order_id, :carrier, :tracking_number, :status,
                  :shipped_at, :delivered_at, :delivery_source,
                  :created_at, :updated_at

      def initialize(attributes = {})
        @id = attributes["id"]
        @order_id = attributes["order_id"]
        @carrier = attributes["carrier"]
        @tracking_number = attributes["tracking_number"]
        @status = attributes["status"]
        @shipped_at = attributes["shipped_at"]
        @delivered_at = attributes["delivered_at"]
        @delivery_source = attributes["delivery_source"]
        @created_at = attributes["created_at"]
        @updated_at = attributes["updated_at"]
      end

      # Builds a Shipment from an API response hash.
      #
      # @param hash [Hash] raw API response data
      # @return [Shipment]
      def self.from_hash(hash)
        new(hash)
      end
    end
  end
end
