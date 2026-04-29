# ActiveAdmin resource for customer management backed by application use case.
ActiveAdmin.register Customer::Record, as: "Customer" do
  menu label: "Customers", priority: 2
  config.filters = false

  actions :index, :show, :new, :create

  permit_params :name, :email

  index download_links: false do
    div class: "u-mb-sm" do
      text_node helpers.render(
        DesignSystem::UI::Components::HeaderComponent.new(
          title: "Customers",
          navigation: [
            {label: "Dashboard", href: "/admin"},
            {label: "Customers", href: "/admin/customers"}
          ]
        )
      )
    end

    div class: "u-mb-sm" do
      text_node helpers.form_with(url: helpers.admin_customers_path, method: :get, local: true, class: "ds-filter-form") {
        helpers.safe_join([
          helpers.render(DesignSystem::UI::Composites::FilterGroupComponent.new(label: "Email")) {
            helpers.safe_join([
              helpers.render(DesignSystem::UI::Primitives::LabelComponent.new(text: "Operator", for_id: "email_operator")),
              helpers.render(
                DesignSystem::UI::Primitives::SelectComponent.new(
                  name: :email_operator,
                  options: [
                    {label: "Contains", value: "contains"},
                    {label: "Equals", value: "eq"}
                  ],
                  value: params[:email_operator] || "contains",
                  classes: "u-mb-sm"
                )
              ),
              helpers.render(
                DesignSystem::UI::Primitives::InputComponent.new(
                  name: :email_query,
                  label: "Email",
                  value: params[:email_query],
                  placeholder: "customer@example.com"
                )
              )
            ])
          },
          helpers.render(DesignSystem::UI::Composites::FilterGroupComponent.new(label: "Name")) {
            helpers.render(
              DesignSystem::UI::Primitives::InputComponent.new(
                name: :name_query,
                label: "Name",
                value: params[:name_query],
                placeholder: "Customer name"
              )
            )
          },
          helpers.content_tag(:div, class: "u-mt-sm") {
            helpers.safe_join([
              helpers.render(DesignSystem::UI::Primitives::ButtonComponent.new(label: "Apply filters", type: :submit, variant: :primary)),
              helpers.tag.span(" "),
              helpers.render(DesignSystem::UI::Primitives::LinkComponent.new(label: "Clear", href: helpers.admin_customers_path, variant: :subtle, size: :sm))
            ])
          }
        ])
      }
    end

    columns = [
      {key: :id, label: "Id", align: :right},
      {key: :name, label: "Name"},
      {key: :email, label: "Email"},
      {key: :created_at, label: "Created At"},
      {key: :actions, label: "Actions", align: :right}
    ]

    rows = collection.map do |record|
      {
        id: record.id,
        name: record.name,
        email: record.email,
        created_at: helpers.l(record.created_at, format: :short),
        actions: record
      }
    end

    div class: "ds-panel" do
      render DesignSystem::UI::Components::TableComponent.new(columns: columns, rows: rows, empty_state: "No customers yet") { |row, column|
        if column[:key] == :actions
          helpers.render(
            DesignSystem::UI::Primitives::LinkComponent.new(
              label: "View",
              href: helpers.admin_customer_path(row[:actions]),
              variant: :default,
              size: :sm
            )
          )
        else
          row[column[:key]]
        end
      }
    end
  end

  show do
    attributes_table do
      row :id
      row :name
      row :email
      row :created_at
      row :updated_at
    end
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :email
    end
    f.actions
  end

  controller do
    def scoped_collection
      scoped = super

      if params[:email_query].present?
        scoped = if params[:email_operator] == "eq"
          scoped.where(email: params[:email_query].strip)
        else
          scoped.where("email ILIKE ?", "%#{params[:email_query].strip}%")
        end
      end

      if params[:name_query].present?
        scoped = scoped.where("name ILIKE ?", "%#{params[:name_query].strip}%")
      end

      scoped
    end

    # @return [void]
    def create
      result = CustomerCore::Application::UseCases::Customer::Create.call(
        repo: Admin::Infrastructure::Repositories::ActiveRecord::CustomerRepository.new,
        publisher: CustomerCore::Application::Interfaces::Events::EventBus.new(
          publisher: Admin::Infrastructure::Events::FaktoryEventBus.new
        ),
        logger: Admin::Infrastructure::Logging::RailsLogger.new,
        notifier: Admin::Infrastructure::Notifications::RailsNotifier.new,
        dead_letter_store: Admin::Infrastructure::Events::RailsDeadLetterStore.new,
        input: customer_params
      )

      unless result.success?
        redirect_to admin_customers_path, alert: result.message
        return
      end

      redirect_to admin_customers_path, notice: "Customer created"
    end

    private

    # @return [Hash]
    def customer_params
      params.require(:customer_record).permit(:name, :email).to_h.symbolize_keys
    end
  end
end
