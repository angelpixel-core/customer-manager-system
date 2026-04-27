if defined?(Lookbook)
  Lookbook.configure do |config|
    config.project_name = "Customers Manager - Design System"
    config.page_paths = [Rails.root.join("docs/lookbook")]
    config.preview_paths = [Rails.root.join("app/components/previews")]
  end
end
