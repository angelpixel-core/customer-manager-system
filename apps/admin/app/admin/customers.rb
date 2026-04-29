# ActiveAdmin resource for customer management backed by application use case.
ActiveAdmin.register Customer::Record, as: "Customer" do
  menu label: "Customers", priority: 2

  actions :index, :show, :new, :create

  permit_params :name, :email

  index download_links: false do
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
