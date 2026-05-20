# frozen_string_literal: true

module TrueTrial
  module Types
    # Represents a webhook subscription returned from the TrueTrial API.
    class WebhookSubscription
      attr_reader :id, :url, :events, :secret, :active,
                  :created_at, :updated_at

      def initialize(attributes = {})
        @id = attributes["id"]
        @url = attributes["url"]
        @events = attributes["events"]
        @secret = attributes["secret"]
        @active = attributes["active"]
        @created_at = attributes["created_at"]
        @updated_at = attributes["updated_at"]
      end

      # Builds a WebhookSubscription from an API response hash.
      #
      # @param hash [Hash] raw API response data
      # @return [WebhookSubscription]
      def self.from_hash(hash)
        new(hash)
      end
    end
  end
end
