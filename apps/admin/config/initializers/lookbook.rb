if defined?(Lookbook)
  Lookbook.configure do |config|
    config.project_name = "Customers Manager - Design System"
    config.page_paths = [Rails.root.join("docs/lookbook")]
    config.preview_paths = [Rails.root.join("app/components/previews")]
  end

  Rails.application.config.to_prepare do
    if defined?(ViewComponent::Preview)
      if ViewComponent::Preview.respond_to?(:load_previews)
        ViewComponent::Preview.load_previews
      elsif ViewComponent::Preview.respond_to?(:__vc_load_previews)
        ViewComponent::Preview.__vc_load_previews
      end
    end
  end
end
