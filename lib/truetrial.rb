# frozen_string_literal: true

require_relative "truetrial/version"
require_relative "truetrial/errors"
require_relative "truetrial/http_client"
require_relative "truetrial/client"
require_relative "truetrial/webhook"

require_relative "truetrial/types/order"
require_relative "truetrial/types/shipment"
require_relative "truetrial/types/temporal_element"
require_relative "truetrial/types/cancellation"
require_relative "truetrial/types/webhook_subscription"

require_relative "truetrial/resources/orders"
require_relative "truetrial/resources/shipments"
require_relative "truetrial/resources/digital_delivery"
require_relative "truetrial/resources/temporal"
require_relative "truetrial/resources/cancellations"
require_relative "truetrial/resources/webhooks"
require_relative "truetrial/resources/system"

module TrueTrial
end
