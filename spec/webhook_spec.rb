# frozen_string_literal: true

require "truetrial"
require "json"
require "openssl"

RSpec.describe TrueTrial::Webhook do
  let(:secret) { "whsec_test_secret_key" }
  let(:payload) { '{"event":"order.created","data":{"id":"01ORDER"}}' }
  let(:valid_signature) { OpenSSL::HMAC.hexdigest("SHA256", secret, payload) }
  let(:timestamp) { Time.now.utc.iso8601 }

  describe ".verify?" do
    it "returns true for a valid signature" do
      expect(described_class.verify?(payload, valid_signature, secret)).to be true
    end

    it "returns false for an invalid signature" do
      expect(described_class.verify?(payload, "invalid_signature", secret)).to be false
    end

    it "returns false when the signature has a different length" do
      expect(described_class.verify?(payload, "short", secret)).to be false
    end

    it "returns false for a tampered payload" do
      tampered = '{"event":"order.created","data":{"id":"01TAMPERED"}}'
      expect(described_class.verify?(tampered, valid_signature, secret)).to be false
    end

    it "returns false for a wrong secret" do
      expect(described_class.verify?(payload, valid_signature, "wrong_secret")).to be false
    end

    context "with timestamp tolerance" do
      it "returns true when the event is within tolerance" do
        expect(
          described_class.verify?(
            payload, valid_signature, secret,
            tolerance: 300, timestamp: timestamp
          )
        ).to be true
      end

      it "returns false when the event is outside tolerance" do
        old_timestamp = (Time.now - 600).utc.iso8601
        expect(
          described_class.verify?(
            payload, valid_signature, secret,
            tolerance: 300, timestamp: old_timestamp
          )
        ).to be false
      end
    end
  end

  describe ".construct_event" do
    it "returns a parsed hash for a valid signature" do
      event = described_class.construct_event(payload, valid_signature, secret)
      expect(event).to be_a(Hash)
      expect(event["event"]).to eq("order.created")
      expect(event["data"]["id"]).to eq("01ORDER")
    end

    it "raises an error for an invalid signature" do
      expect {
        described_class.construct_event(payload, "bad_sig", secret)
      }.to raise_error(TrueTrial::Error, "Invalid webhook signature")
    end
  end

  describe ".compute_signature" do
    it "produces a hex-encoded HMAC SHA-256 digest" do
      result = described_class.compute_signature(payload, secret)
      expected = OpenSSL::HMAC.hexdigest("SHA256", secret, payload)
      expect(result).to eq(expected)
    end

    it "produces different signatures for different payloads" do
      sig_a = described_class.compute_signature("payload_a", secret)
      sig_b = described_class.compute_signature("payload_b", secret)
      expect(sig_a).not_to eq(sig_b)
    end

    it "produces different signatures for different secrets" do
      sig_a = described_class.compute_signature(payload, "secret_a")
      sig_b = described_class.compute_signature(payload, "secret_b")
      expect(sig_a).not_to eq(sig_b)
    end
  end
end
