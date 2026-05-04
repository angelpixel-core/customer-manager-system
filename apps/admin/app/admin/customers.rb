# ActiveAdmin resource for customer management backed by application use case.
ActiveAdmin.register Customer::Record do
  menu label: "Customers", priority: 2

  actions :index, :show, :new, :create

  permit_params :name, :email

  index do
    id_column
    column :name
    column :email
    column :created_at
    actions
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
