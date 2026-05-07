# frozen_string_literal: true

module TrueTrial
  module Types
    # Represents a temporal element (trial, warranty, subscription, etc.)
    # returned from the TrueTrial API.
    class TemporalElement
      attr_reader :id, :order_id, :type, :status, :duration, :duration_unit,
                  :begins_at, :expires_at, :converted_at, :cancelled_at,
                  :created_at, :updated_at

      def initialize(attributes = {})
        @id = attributes["id"]
        @order_id = attributes["order_id"]
        @type = attributes["type"]
        @status = attributes["status"]
        @duration = attributes["duration"]
        @duration_unit = attributes["duration_unit"]
        @begins_at = attributes["begins_at"]
        @expires_at = attributes["expires_at"]
        @converted_at = attributes["converted_at"]
        @cancelled_at = attributes["cancelled_at"]
        @created_at = attributes["created_at"]
        @updated_at = attributes["updated_at"]
      end

      # Builds a TemporalElement from an API response hash.
      #
      # @param hash [Hash] raw API response data
      # @return [TemporalElement]
      def self.from_hash(hash)
        new(hash)
      end
    end
  end
end
