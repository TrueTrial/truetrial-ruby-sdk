# frozen_string_literal: true

module TrueTrial
  # Main entry point for interacting with the TrueTrial API.
  #
  # @example
  #   client = TrueTrial::Client.new(api_key: "tt_live_abc123")
  #   client.orders.list
  class Client
    DEFAULT_BASE_URL = "https://truetrial.test/api/v1"

    # @param api_key [String] your TrueTrial API key
    # @param base_url [String] API base URL (defaults to production)
    def initialize(api_key:, base_url: DEFAULT_BASE_URL)
      @http_client = HttpClient.new(api_key: api_key, base_url: base_url)
    end

    # @return [TrueTrial::Resources::Orders]
    def orders
      @orders ||= Resources::Orders.new(@http_client)
    end

    # @return [TrueTrial::Resources::Shipments]
    def shipments
      @shipments ||= Resources::Shipments.new(@http_client)
    end

    # @return [TrueTrial::Resources::DigitalDelivery]
    def digital_delivery
      @digital_delivery ||= Resources::DigitalDelivery.new(@http_client)
    end

    # @return [TrueTrial::Resources::Temporal]
    def temporal
      @temporal ||= Resources::Temporal.new(@http_client)
    end

    # @return [TrueTrial::Resources::Cancellations]
    def cancellations
      @cancellations ||= Resources::Cancellations.new(@http_client)
    end

    # @return [TrueTrial::Resources::Webhooks]
    def webhooks
      @webhooks ||= Resources::Webhooks.new(@http_client)
    end

    # @return [TrueTrial::Resources::System]
    def system
      @system ||= Resources::System.new(@http_client)
    end
  end
end
