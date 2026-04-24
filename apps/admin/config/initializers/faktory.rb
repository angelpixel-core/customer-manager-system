require "faktory_worker_ruby"

Faktory.configure_worker do |config|
  config.url = ENV.fetch("FAKTORY_URL", "tcp://localhost:7419")
end
