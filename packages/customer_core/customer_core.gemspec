require_relative "lib/customer_core/version"

Gem::Specification.new do |spec|
  spec.name          = "customer_core"
  spec.version       = CustomerCore::VERSION
  spec.authors       = ["Angel"]
  spec.email         = ["you@example.com"]

  spec.summary       = "Domain core for Customers Manager System"
  spec.description   = "DDD + Hexagonal domain layer for customer management"
  spec.homepage      = "https://github.com/angelpixel-core/customers-manager-system"
  spec.license       = "MIT"

  spec.required_ruby_version = ">= 3.2.0"

  spec.files = Dir.glob("lib/**/*")

  spec.require_paths = ["lib"]
end
