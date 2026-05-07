# frozen_string_literal: true

module TrueTrial
  module Types
    # Represents a cancellation returned from the TrueTrial API.
    class Cancellation
      attr_reader :id, :order_id, :reason, :cancelled_by, :notes,
                  :created_at, :updated_at

      def initialize(attributes = {})
        @id = attributes["id"]
        @order_id = attributes["order_id"]
        @reason = attributes["reason"]
        @cancelled_by = attributes["cancelled_by"]
        @notes = attributes["notes"]
        @created_at = attributes["created_at"]
        @updated_at = attributes["updated_at"]
      end

      # Builds a Cancellation from an API response hash.
      #
      # @param hash [Hash] raw API response data
      # @return [Cancellation]
      def self.from_hash(hash)
        new(hash)
      end
    end
  end
end
