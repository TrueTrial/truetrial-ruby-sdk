# frozen_string_literal: true

require_relative "lib/truetrial/version"

Gem::Specification.new do |spec|
  spec.name = "truetrial"
  spec.version = TrueTrial::VERSION
  spec.authors = ["TrueTrial"]
  spec.email = ["support@truetrial.com"]

  spec.summary = "Ruby SDK for the TrueTrial API"
  spec.description = "Official Ruby client for the TrueTrial compliance-first trial and warranty management platform."
  spec.homepage = "https://github.com/truetrial/truetrial-ruby-sdk"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.1"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "#{spec.homepage}/blob/main/CHANGELOG.md"

  spec.files = Dir["lib/**/*.rb", "README.md", "LICENSE.txt", "CHANGELOG.md"]
  spec.require_paths = ["lib"]

  spec.add_dependency "faraday", "~> 2.0"

  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "webmock", "~> 3.0"
end
