class ApplicationController < ActionController::Base
  include Pundit::Authorization
    before_action :configure_permitted_parameters, if: :devise_controller?

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes
  # Very important — catches unauthorized access
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  protected

def configure_permitted_parameters
  devise_parameter_sanitizer.permit(
    :sign_up,
    keys: [:first_name, :last_name]
  )

  devise_parameter_sanitizer.permit(
    :account_update,
    keys: [:first_name, :last_name]
  )
end

  private

  def user_not_authorized
    flash[:alert] = "You are not allowed to do that."
    redirect_back(fallback_location: dashboard_path)
  end

  # Makes current_user available to policies
  def pundit_user
    current_user
  end
end
