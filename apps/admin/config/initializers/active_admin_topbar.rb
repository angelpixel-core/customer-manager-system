module ActiveAdmin
  module Views
    class Header
      def build(namespace, menu)
        super(id: "header")

        text_node helpers.render(
          DesignSystem::UI::Components::HeaderComponent.new(
            title: "CUSTOMERS MANAGER SYSTEM",
            navigation: topbar_navigation
          )
        )
      end

      private

      def topbar_navigation
        links = [{label: "Home", href: "/"}]

        if admin_logged_in?
          links.concat([
            {label: "Customers", href: "/admin/customers"},
            {label: "Admin", href: "/admin"},
            {label: "Logout", href: "/logout", html_options: {data: {turbo_method: :post}}}
          ])
        else
          links.concat([
            {label: "Login", href: "/login"},
            {label: "Admin", href: "/admin"}
          ])
        end

        links
      end

      def admin_logged_in?
        current_user.present?
      end

      def current_user
        if helpers.respond_to?(:current_admin) && helpers.current_admin.present?
          return helpers.current_admin
        end

        if helpers.respond_to?(:current_active_admin_user) && helpers.current_active_admin_user.present?
          return helpers.current_active_admin_user
        end

        nil
      end
    end
  end
end
