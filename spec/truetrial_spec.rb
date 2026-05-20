# frozen_string_literal: true

require "truetrial"
require "webmock/rspec"

RSpec.describe TrueTrial do
  it "has a version number" do
    expect(TrueTrial::VERSION).to eq("1.0.0")
  end
end

RSpec.describe TrueTrial::Client do
  let(:api_key) { "tt_test_abc123" }
  let(:base_url) { "https://truetrial.test/api/v1" }
  let(:client) { described_class.new(api_key: api_key, base_url: base_url) }

  describe "#initialize" do
    it "creates a client with an API key" do
      expect(client).to be_a(TrueTrial::Client)
    end

    it "uses the default base URL when none is provided" do
      default_client = described_class.new(api_key: api_key)
      expect(default_client).to be_a(TrueTrial::Client)
    end
  end

  describe "resource accessors" do
    it "returns an Orders resource" do
      expect(client.orders).to be_a(TrueTrial::Resources::Orders)
    end

    it "returns a Shipments resource" do
      expect(client.shipments).to be_a(TrueTrial::Resources::Shipments)
    end

    it "returns a DigitalDelivery resource" do
      expect(client.digital_delivery).to be_a(TrueTrial::Resources::DigitalDelivery)
    end

    it "returns a Temporal resource" do
      expect(client.temporal).to be_a(TrueTrial::Resources::Temporal)
    end

    it "returns a Cancellations resource" do
      expect(client.cancellations).to be_a(TrueTrial::Resources::Cancellations)
    end

    it "returns a Webhooks resource" do
      expect(client.webhooks).to be_a(TrueTrial::Resources::Webhooks)
    end

    it "returns a System resource" do
      expect(client.system).to be_a(TrueTrial::Resources::System)
    end

    it "memoizes resource instances" do
      expect(client.orders).to equal(client.orders)
      expect(client.shipments).to equal(client.shipments)
      expect(client.temporal).to equal(client.temporal)
    end
  end

  describe "API requests" do
    before { WebMock.enable! }
    after { WebMock.disable! }

    it "sends the API key header on requests" do
      stub = stub_request(:get, "#{base_url}/orders")
        .with(headers: { "X-Api-Key" => api_key })
        .to_return(status: 200, body: '{"data": []}', headers: { "Content-Type" => "application/json" })

      client.orders.list
      expect(stub).to have_been_requested
    end

    it "raises AuthenticationError on 401" do
      stub_request(:get, "#{base_url}/orders")
        .to_return(status: 401, body: '{"message": "Unauthenticated"}')

      expect { client.orders.list }.to raise_error(TrueTrial::AuthenticationError)
    end

    it "raises NotFoundError on 404" do
      stub_request(:get, "#{base_url}/orders/nonexistent")
        .to_return(status: 404, body: '{"message": "Not found"}')

      expect { client.orders.get("nonexistent") }.to raise_error(TrueTrial::NotFoundError)
    end

    it "raises ValidationError on 422" do
      body = '{"message": "Validation failed", "errors": {"email": ["is required"]}}'
      stub_request(:post, "#{base_url}/orders")
        .to_return(status: 422, body: body)

      expect { client.orders.create({}) }.to raise_error(TrueTrial::ValidationError) do |error|
        expect(error.errors).to eq("email" => ["is required"])
      end
    end

    it "raises RateLimitError on 429" do
      stub_request(:get, "#{base_url}/orders")
        .to_return(status: 429, body: '{"message": "Too many requests"}', headers: { "Retry-After" => "30" })

      expect { client.orders.list }.to raise_error(TrueTrial::RateLimitError) do |error|
        expect(error.retry_after).to eq(30)
      end
    end

    it "raises ServerError on 500" do
      stub_request(:get, "#{base_url}/orders")
        .to_return(status: 500, body: '{"message": "Internal server error"}')

      expect { client.orders.list }.to raise_error(TrueTrial::ServerError)
    end

    it "creates a shipment with the correct path" do
      order_id = "01HXYZ"
      stub = stub_request(:post, "#{base_url}/orders/#{order_id}/shipments")
        .to_return(status: 201, body: '{"id": "01SHIP"}')

      client.shipments.create(order_id, { carrier: "ups", tracking_number: "1Z999" })
      expect(stub).to have_been_requested
    end

    it "deletes a webhook" do
      stub = stub_request(:delete, "#{base_url}/webhooks/01WH")
        .to_return(status: 200, body: '{"deleted": true}')

      client.webhooks.delete("01WH")
      expect(stub).to have_been_requested
    end
  end
end
