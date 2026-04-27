class CustomersController < ApplicationController
  before_action :authenticate_admin

  # @return [void]
  def index
    @customers = Customer::Record.order(created_at: :desc).limit(20)
  end

  # @return [void]
  def create
    use_case = CustomerCore::Application::UseCases::Customer::Create.new(
      repo: Admin::Infrastructure::Repositories::ActiveRecord::CustomerRepository.new,
      event_bus: Admin::Infrastructure::Events::FaktoryEventBus.new
    )

    use_case.call(customer_params)

    redirect_to admin_customers_path
  end

  private

  # @return [Hash]
  def customer_params
    params.permit(:name, :email).to_h.symbolize_keys
  end
end
