# TrueTrial Ruby SDK

Official Ruby client for the [TrueTrial](https://truetrial.com) API -- compliance-first trial, warranty, and subscription management.

## Requirements

- Ruby >= 3.1
- Faraday ~> 2.0

## Installation

Add to your Gemfile:

```ruby
gem "truetrial", "~> 1.0"
```

Then run:

```sh
bundle install
```

Or install directly:

```sh
gem install truetrial
```

## Quick Start

```ruby
require "truetrial"

client = TrueTrial::Client.new(api_key: "tt_live_your_key_here")

# List orders
orders = client.orders.list(status: "trial_active", page: 1)

# Create an order
order = client.orders.create(
  external_order_id: "ORD-12345",
  product_type: "physical",
  total_cents: 4999,
  currency: "USD"
)

# Get order details
order = client.orders.get("01HXYZ...")

# Check order status
status = client.orders.status("01HXYZ...")
```

## Configuration

```ruby
client = TrueTrial::Client.new(
  api_key: "tt_live_your_key_here",
  base_url: "https://truetrial.test/api/v1"  # default
)
```

## API Reference

### Orders

```ruby
client.orders.list(status: "delivered", page: 2)
client.orders.create(external_order_id: "ORD-123", product_type: "physical", total_cents: 2999)
client.orders.get("01HXYZ")
client.orders.status("01HXYZ")
```

### Shipments

```ruby
client.shipments.create("01ORDER_ID", carrier: "ups", tracking_number: "1Z999AA10123456784")
client.shipments.list("01ORDER_ID")
```

### Digital Delivery

```ruby
client.digital_delivery.confirm("01ORDER_ID", delivered_at: "2026-01-15T10:00:00Z")
```

### Temporal Elements (Trials, Warranties, etc.)

```ruby
client.temporal.get("01ORDER_ID")
client.temporal.extend("01ORDER_ID", duration: 7, unit: "days", reason: "Customer request")
client.temporal.adjust("01ORDER_ID", begins_at: "2026-01-20T00:00:00Z")
client.temporal.claim("01ORDER_ID", reason: "Product defect", description: "Screen cracked on arrival")
client.temporal.resolve_claim("01ORDER_ID", status: "claim_approved", notes: "Replacement shipped")
```

### Cancellations

```ruby
client.cancellations.create("01ORDER_ID", reason: "Changed mind")
client.cancellations.get("01ORDER_ID")
```

### Webhooks

```ruby
client.webhooks.list
client.webhooks.create(url: "https://example.com/webhooks", events: ["order.delivered", "trial.started"])
client.webhooks.delete("01WEBHOOK_ID")
```

### System

```ruby
client.system.carrier_health
```

## Error Handling

All API errors inherit from `TrueTrial::Error`:

```ruby
begin
  client.orders.get("nonexistent")
rescue TrueTrial::AuthenticationError => e
  # 401 - Invalid or missing API key
  puts e.message
rescue TrueTrial::NotFoundError => e
  # 404 - Resource not found
  puts e.message
rescue TrueTrial::ValidationError => e
  # 422 - Validation failed
  puts e.errors  # => { "email" => ["is required"] }
rescue TrueTrial::RateLimitError => e
  # 429 - Too many requests
  puts "Retry after #{e.retry_after} seconds"
rescue TrueTrial::ServerError => e
  # 500+ - Server error
  puts e.status_code
rescue TrueTrial::Error => e
  # Catch-all for unexpected errors
  puts e.message
end
```

## Webhook Verification

TrueTrial signs webhook payloads with HMAC SHA-256. Verify incoming webhooks to ensure authenticity:

```ruby
# In your webhook controller / endpoint
payload = request.body.read
signature = request.headers["X-TrueTrial-Signature"]
timestamp = request.headers["X-TrueTrial-Timestamp"]
event_name = request.headers["X-TrueTrial-Event"]
secret = "whsec_your_webhook_secret"

# Simple verification (returns boolean)
if TrueTrial::Webhook.verify?(payload, signature, secret)
  event = JSON.parse(payload)
  # process event...
end

# Verify with timestamp tolerance (recommended for production)
if TrueTrial::Webhook.verify?(payload, signature, secret, tolerance: 300, timestamp: timestamp)
  event = JSON.parse(payload)
  # process event...
end

# Or use construct_event to verify and parse in one step (raises on failure)
begin
  event = TrueTrial::Webhook.construct_event(payload, signature, secret, tolerance: 300, timestamp: timestamp)

  case event_name
  when "order.delivered"
    handle_delivery(event["data"])
  when "trial.started"
    handle_trial_start(event["data"])
  when "trial.expiring"
    handle_trial_expiring(event["data"])
  end
rescue TrueTrial::Error => e
  # Invalid signature
  render json: { error: e.message }, status: 400
end
```

## Enums

The following string values are used across the API:

**OrderStatus:** `received`, `shipped`, `in_transit`, `delivered`, `trial_active`, `converted`, `returned`, `expired`, `cancelled`

**TemporalType:** `trial`, `evaluation`, `subscription`, `warranty`, `guarantee`

**TemporalStatus:** `pending`, `active`, `expiring`, `expired`, `converted`, `cancelled`, `suspended`, `renewed`, `claimed`, `claim_approved`, `claim_denied`

**ShipmentStatus:** `pending`, `in_transit`, `out_for_delivery`, `delivered`, `failed`, `returned_to_sender`

**ProductType:** `physical`, `digital`

**Carrier:** `ups`, `fedex`, `usps`, `dhl`, `shippo`, `aftership`

**DurationUnit:** `days`, `weeks`, `months`, `years`

**DeliverySource:** `webhook`, `poll`, `manual`, `fallback_carrier`

**WebhookEvent:** `order.created`, `order.delivered`, `trial.started`, `trial.expiring`, `trial.expired`, `trial.converted`, `cancellation.initiated`, `risk_score.changed`, `subscription.renewed`, `warranty.claimed`, `temporal.extended`, `temporal.adjusted`, `warranty.claim_resolved`, `payment.succeeded`, `payment.failed`, `dispute.created`, `dispute.won`, `dispute.lost`

## Type Objects

The SDK provides type classes for deserializing API responses:

```ruby
data = client.orders.get("01HXYZ")
order = TrueTrial::Types::Order.from_hash(data)
puts order.id
puts order.status
```

Available types: `Order`, `Shipment`, `TemporalElement`, `Cancellation`, `WebhookSubscription`

## Development

```sh
bundle install
bundle exec rspec
```

## License

MIT
