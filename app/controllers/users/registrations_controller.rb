# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  # GET /secure/confirm_delete
  def confirm_delete
  end

  # Ensure we redirect to a public page with a clear flash after account deletion
  def destroy
    resource = resource_class.to_adapter.get!(send("current_#{resource_name}").to_key)

    begin
      # Destroy user account
      if resource.destroy
        # Sign out and set the Devise flash message
        Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name)
        redirect_to(home_path, status: :see_other, notice: find_message(:destroyed))
      else
        # If resource was not destroyed due to validation errors
        redirect_to(edit_user_registration_path, alert: resource.errors.full_messages.to_sentence)
      end
    rescue => e
      # Log the error for debugging
      Rails.logger.error "Failed to delete user account: #{e.message}"
      Rails.logger.error e.backtrace.join("\n")

      # Redirect with helpful error message
      redirect_to(edit_user_registration_path,
                 alert: "Unable to delete account due to a system error. Please try again later or contact support.")
    end
  end
end
