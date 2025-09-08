class Users::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  def new
    Rails.logger.debug("SessionsController#new called")
    super
  end

  # POST /resource/sign_in
  def create
    Rails.logger.debug("SessionsController#create called with params: #{params.except(:password).inspect}")
    begin
      super
    rescue => e
      Rails.logger.error("Error in SessionsController#create: #{e.class} - #{e.message}")
      Rails.logger.error(e.backtrace.join("\n"))
      flash[:alert] = "Authentication failed. Please try again."
      redirect_to new_user_session_path
    end
  end

  # DELETE /resource/sign_out
  def destroy
    Rails.logger.debug("SessionsController#destroy called")
    begin
      super
    rescue => e
      Rails.logger.error("Error in SessionsController#destroy: #{e.class} - #{e.message}")
      Rails.logger.error(e.backtrace.join("\n"))
      sign_out(current_user) if user_signed_in?
      redirect_to root_path
    end
  end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
