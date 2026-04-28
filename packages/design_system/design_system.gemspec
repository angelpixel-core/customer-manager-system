require_relative "lib/design_system/version"

Gem::Specification.new do |spec|
  spec.name = "design_system"
  spec.version = DesignSystem::VERSION
  spec.authors = ["Angel"]
  spec.email = ["you@example.com"]

  spec.summary = "Shared UI design system for Customers Manager"
  spec.description = "Atomic Design package with tokens, components, rules, and docs"
  spec.homepage = "https://github.com/angelpixel-core/customers-manager-system"
  spec.license = "Apache-2.0"
  spec.required_ruby_version = ">= 3.2.0"

  spec.files = Dir.glob("{lib,app,docs}/**/*") + ["README.md"]
  spec.require_paths = ["lib"]

  spec.add_dependency "rails", ">= 8.1"
  spec.add_dependency "view_component", "~> 4.8"

  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "yard", "~> 0.9.37"
end
