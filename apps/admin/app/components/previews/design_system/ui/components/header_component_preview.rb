module DesignSystem
  module UI
    module Components
      class HeaderComponentPreview < ViewComponent::Preview
        def basic
          render DesignSystem::UI::Components::HeaderComponent.new(
            title: "Customers Manager",
            navigation: [
              {label: "Dashboard", href: "/admin"},
              {label: "Customers", href: "/admin/customers"}
            ],
            user_email: "admin@example.com"
          )
        end
      end
    end
  end
end
