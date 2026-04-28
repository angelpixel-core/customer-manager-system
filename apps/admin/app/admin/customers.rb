# ActiveAdmin resource for customer management backed by application use case.
ActiveAdmin.register Customer::Record do
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
          helpers.link_to("View", helpers.admin_customer_record_path(row[:actions]), class: "ds-button ds-button--link ds-button--sm")
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
        flash.now[:error] = result.message
        @customer_record = Customer::Record.new(customer_params)
        render :new, status: :unprocessable_entity
        return
      end

      redirect_to admin_customer_records_path, notice: "Customer created"
    end

    private

    # @return [Hash]
    def customer_params
      params.require(:customer_record).permit(:name, :email).to_h.symbolize_keys
    end
  end
end
