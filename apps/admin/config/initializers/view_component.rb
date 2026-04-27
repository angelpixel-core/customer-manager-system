Rails.application.configure do
  config.view_component.generate.sidecar = true
  config.view_component.generate.preview = true
  config.view_component.preview_paths << Rails.root.join("app/components/previews")
end
