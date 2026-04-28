module Admin
  class CustomersExtensionsController < ApplicationController
    before_action :authenticate_admin

    def health
      render json: {status: "ok"}
    end
  end
end
