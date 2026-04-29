module DesignSystem
  module UI
    module Components
      class PageHeaderComponentPreview < ViewComponent::Preview
        def basic
          render DesignSystem::UI::Components::PageHeaderComponent.new(title: "Customers")
        end

        def with_actions
          render DesignSystem::UI::Components::PageHeaderComponent.new(title: "Customers") do
            helpers.safe_join([export_button, add_customer_button])
          end
        end

        private

        def export_button
          helpers.link_to("Export CSV", "/admin/customers.csv", class: "ds-button ds-button--secondary ds-button--sm")
        end

        def add_customer_button
          helpers.link_to("Add customer", "/admin/customers/new", class: "ds-button ds-button--primary ds-button--sm")
        end
      end
    end
  end
end
