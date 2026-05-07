# frozen_string_literal: true

require "faraday"
require "json"

module TrueTrial
  # Low-level HTTP client wrapping Faraday for TrueTrial API communication.
  class HttpClient
    def initialize(api_key:, base_url:)
      @connection = Faraday.new(url: base_url) do |conn|
        conn.headers["X-Api-Key"] = api_key
        conn.headers["Content-Type"] = "application/json"
        conn.headers["Accept"] = "application/json"
        conn.headers["User-Agent"] = "truetrial-ruby/#{TrueTrial::VERSION}"
        conn.adapter Faraday.default_adapter
      end
    end

    # Performs a GET request.
    #
    # @param path [String] the API endpoint path
    # @param params [Hash] optional query parameters
    # @return [Hash] parsed JSON response
    def get(path, params: {})
      response = @connection.get(path) do |req|
        req.params = params unless params.empty?
      end
      handle_response(response)
    end

    # Performs a POST request.
    #
    # @param path [String] the API endpoint path
    # @param body [Hash] the request body
    # @return [Hash] parsed JSON response
    def post(path, body: {})
      response = @connection.post(path) do |req|
        req.body = JSON.generate(body)
      end
      handle_response(response)
    end

    # Performs a DELETE request.
    #
    # @param path [String] the API endpoint path
    # @return [Hash] parsed JSON response
    def delete(path)
      response = @connection.delete(path)
      handle_response(response)
    end

    private

    # Maps HTTP status codes to appropriate error classes.
    #
    # @param response [Faraday::Response]
    # @return [Hash] parsed response body on success
    # @raise [TrueTrial::Error] on error responses
    def handle_response(response)
      body = parse_body(response.body)

      case response.status
      when 200..299
        body
      when 401
        raise AuthenticationError.new(
          error_message(body, "Invalid or missing API key"),
          response_body: body
        )
      when 404
        raise NotFoundError.new(
          error_message(body, "Resource not found"),
          response_body: body
        )
      when 422
        raise ValidationError.new(
          error_message(body, "Validation failed"),
          errors: body.is_a?(Hash) ? body.fetch("errors", {}) : {},
          response_body: body
        )
      when 429
        retry_after = response.headers["Retry-After"]&.to_i
        raise RateLimitError.new(
          error_message(body, "Rate limit exceeded"),
          retry_after: retry_after,
          response_body: body
        )
      when 500..599
        raise ServerError.new(
          error_message(body, "Internal server error"),
          status_code: response.status,
          response_body: body
        )
      else
        raise Error.new(
          error_message(body, "Unexpected response"),
          status_code: response.status,
          response_body: body
        )
      end
    end

    # Safely parses JSON, returning the raw string on failure.
    def parse_body(raw)
      return nil if raw.nil? || raw.empty?

      JSON.parse(raw)
    rescue JSON::ParserError
      raw
    end

    # Extracts an error message from the response body hash.
    def error_message(body, default)
      return default unless body.is_a?(Hash)

      body["message"] || body["error"] || default
    end
  end
end
