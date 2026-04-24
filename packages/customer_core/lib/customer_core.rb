# frozen_string_literal: true

require_relative "customer_core/version"
require "zeitwerk"

loader = Zeitwerk::Loader.for_gem

loader.setup

module CustomerCore
end
