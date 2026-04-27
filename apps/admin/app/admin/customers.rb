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
      use_case = CustomerCore::Application::UseCases::Customer::Create.new(
        repo: Admin::Infrastructure::Repositories::ActiveRecord::CustomerRepository.new,
        event_bus: Admin::Infrastructure::Events::FaktoryEventBus.new
      )

      use_case.call(customer_params)

      redirect_to admin_customer_records_path, notice: "Customer created"
    rescue ArgumentError, ActiveRecord::RecordInvalid => e
      flash.now[:error] = e.message
      @customer_record = Customer::Record.new(customer_params)
      render :new, status: :unprocessable_entity
    end

    private

    # @return [Hash]
    def customer_params
      params.require(:customer_record).permit(:name, :email).to_h.symbolize_keys
    end
  end
end
