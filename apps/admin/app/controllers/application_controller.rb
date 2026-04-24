class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  def authenticate_admin
    rodauth.require_authentication
  end

  def current_admin
    rodauth.rails_account
  end
end
