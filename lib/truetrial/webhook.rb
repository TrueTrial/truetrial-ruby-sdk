# frozen_string_literal: true

require "openssl"
require "json"
require "time"

module TrueTrial
  # Utilities for verifying and parsing incoming TrueTrial webhooks.
  #
  # Webhook payloads are signed with HMAC SHA-256. The signature is delivered
  # in the X-TrueTrial-Signature header and is computed from the raw JSON body
  # using the webhook secret.
  module Webhook
    module_function

    # Verifies that a webhook payload matches its signature.
    #
    # @param payload [String] the raw JSON request body
    # @param signature [String] the value of the X-TrueTrial-Signature header
    # @param secret [String] the webhook signing secret
    # @param tolerance [Integer, nil] maximum age of the event in seconds (optional)
    # @param timestamp [String, nil] the value of the X-TrueTrial-Timestamp header (required when tolerance is set)
    # @return [Boolean] true if the signature is valid
    def verify?(payload, signature, secret, tolerance: nil, timestamp: nil)
      expected = compute_signature(payload, secret)
      valid = secure_compare(expected, signature)

      if valid && tolerance && timestamp
        event_time = Time.parse(timestamp)
        valid = (Time.now - event_time).abs <= tolerance
      end

      valid
    rescue ArgumentError, TypeError
      false
    end

    # Verifies and parses a webhook payload into a hash.
    #
    # @param payload [String] the raw JSON request body
    # @param signature [String] the value of the X-TrueTrial-Signature header
    # @param secret [String] the webhook signing secret
    # @param tolerance [Integer, nil] maximum age of the event in seconds (optional)
    # @param timestamp [String, nil] the value of the X-TrueTrial-Timestamp header (required when tolerance is set)
    # @return [Hash] the parsed event data
    # @raise [TrueTrial::Error] if the signature is invalid
    def construct_event(payload, signature, secret, tolerance: nil, timestamp: nil)
      unless verify?(payload, signature, secret, tolerance: tolerance, timestamp: timestamp)
        raise Error.new("Invalid webhook signature")
      end

      JSON.parse(payload)
    end

    # Computes the HMAC SHA-256 hex digest for a payload.
    #
    # @param payload [String] the raw payload
    # @param secret [String] the signing secret
    # @return [String] hex-encoded HMAC signature
    def compute_signature(payload, secret)
      OpenSSL::HMAC.hexdigest("SHA256", secret, payload)
    end

    # Performs a constant-time string comparison to prevent timing attacks.
    #
    # @param a [String]
    # @param b [String]
    # @return [Boolean]
    def secure_compare(a, b)
      return false unless a.bytesize == b.bytesize

      OpenSSL.fixed_length_secure_compare(a, b)
    rescue NoMethodError
      # Fallback for older OpenSSL versions
      l = a.unpack("C*")
      r = b.unpack("C*")
      result = 0
      l.zip(r) { |x, y| result |= x ^ y }
      result.zero?
    end
  end
end
