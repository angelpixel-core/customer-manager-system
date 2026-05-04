module DesignSystem
  class Engine < ::Rails::Engine
    isolate_namespace DesignSystem

    initializer "design_system.assets" do |app|
      app.config.assets.paths << root.join("app/assets/stylesheets")
    end
  end
end
