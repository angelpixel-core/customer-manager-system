class CustomersController < ApplicationController
  before_action :authenticate_admin

  # @return [void]
  def index
    @customers = Customer::Record.order(created_at: :desc).limit(20)
  end

  # @return [void]
  def create
    CustomerCore::Application::UseCases::Customer::Create.call(
      repo: Admin::Infrastructure::Repositories::ActiveRecord::CustomerRepository.new,
      event_bus: Admin::Infrastructure::Events::FaktoryEventBus.new,
      input: customer_params
    )

    redirect_to admin_customers_path
  end

  private

  # @return [Hash]
  def customer_params
    params.permit(:name, :email).to_h.symbolize_keys
  end
end
