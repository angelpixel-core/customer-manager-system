Rails.application.configure do
  config.view_component.generate.sidecar = true
  config.view_component.generate.preview = true

  preview_paths = Array(config.view_component.preview_paths)
  app_previews_path = Rails.root.join("app/components/previews")
  config.view_component.preview_paths = (preview_paths + [app_previews_path]).uniq

  if config.view_component.respond_to?(:previews)
    configured_paths = Array(config.view_component.previews.paths)
    config.view_component.previews.paths = (configured_paths + [app_previews_path]).uniq
  end
end
