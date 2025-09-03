class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  before_action :set_locale

  private

  def set_locale
    available = I18n.available_locales.map(&:to_s)
    I18n.locale = params[:locale].presence_in(available) || I18n.default_locale
  end

  def default_url_options
    { locale: I18n.locale }
  end

  # Ensure Devise redirects after sign-out/account deletion to a public page
  # so we don't hit authenticated-only root and lose the intended flash.
  def after_sign_out_path_for(_resource_or_scope)
    home_path
  end
end
