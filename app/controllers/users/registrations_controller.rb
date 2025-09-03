# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  # GET /secure/confirm_delete
  def confirm_delete
  end

  # Ensure we redirect to a public page with a clear flash after account deletion
  def destroy
    resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)

    # Destroy user account
    resource.destroy

    # Sign out and set the Devise flash message
    Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name)
    redirect_to(home_path, status: :see_other, notice: find_message(:destroyed))
  end
end
