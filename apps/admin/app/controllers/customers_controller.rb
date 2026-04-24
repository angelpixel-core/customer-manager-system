class CustomersController < ApplicationController
  def index
    head :ok
  end

  def create
    use_case = CustomerCore::Application::UseCases::Customer::Create.new(
      repo: Admin::Infrastructure::Repositories::ActiveRecord::CustomerRepository.new,
      event_bus: Admin::Infrastructure::Events::FaktoryEventBus.new
    )

    use_case.call(customer_params)

    redirect_to admin_customers_path
  end

  private

  def customer_params
    params.permit(:name, :email).to_h.symbolize_keys
  end
end
