# frozen_string_literal: true

return unless Rails.env.test?
return unless ENV["BULLET_DIAGNOSTIC"] == "1"
return unless defined?(Bullet)

Bullet.enable = true
Bullet.bullet_logger = true
Bullet.raise = ENV["BULLET_STRICT"] == "1"
Bullet.n_plus_one_query_enable = true
Bullet.unused_eager_loading_enable = true
Bullet.counter_cache_enable = true
