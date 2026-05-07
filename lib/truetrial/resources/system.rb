# frozen_string_literal: true

module TrueTrial
  module Resources
    # Provides access to system-level API endpoints.
    class System
      def initialize(http_client)
        @http = http_client
      end

      # Retrieves carrier health status.
      #
      # @return [Hash] carrier health information
      def carrier_health
        @http.get("/carrier-health")
      end
    end
  end
end
