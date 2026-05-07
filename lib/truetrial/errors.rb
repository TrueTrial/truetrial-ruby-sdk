# frozen_string_literal: true

module TrueTrial
  # Base error class for all TrueTrial API errors.
  class Error < StandardError
    attr_reader :status_code, :response_body

    def initialize(message = nil, status_code: nil, response_body: nil)
      @status_code = status_code
      @response_body = response_body
      super(message)
    end
  end

  # Raised when the API key is missing or invalid (HTTP 401).
  class AuthenticationError < Error
    def initialize(message = "Invalid or missing API key", response_body: nil)
      super(message, status_code: 401, response_body: response_body)
    end
  end

  # Raised when request validation fails (HTTP 422).
  class ValidationError < Error
    attr_reader :errors

    def initialize(message = "Validation failed", errors: {}, response_body: nil)
      @errors = errors
      super(message, status_code: 422, response_body: response_body)
    end
  end

  # Raised when the requested resource is not found (HTTP 404).
  class NotFoundError < Error
    def initialize(message = "Resource not found", response_body: nil)
      super(message, status_code: 404, response_body: response_body)
    end
  end

  # Raised when the rate limit is exceeded (HTTP 429).
  class RateLimitError < Error
    attr_reader :retry_after

    def initialize(message = "Rate limit exceeded", retry_after: nil, response_body: nil)
      @retry_after = retry_after
      super(message, status_code: 429, response_body: response_body)
    end
  end

  # Raised when the server returns a 5xx error.
  class ServerError < Error
    def initialize(message = "Internal server error", status_code: 500, response_body: nil)
      super(message, status_code: status_code, response_body: response_body)
    end
  end
end
