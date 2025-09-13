class NavbarComponent < ViewComponent::Base
  include ActionView::Helpers::TranslationHelper
  
  def initialize(current_user: nil)
    @current_user = current_user
  end
  
  def user_signed_in?
    @current_user.present?
  end
  
  # Helper method to safely generate URLs in tests and production
  def locale_url(locale)
    if helpers.respond_to?(:url_for)
      begin
        helpers.url_for(locale: locale)
      rescue ActionController::UrlGenerationError
        # Fallback for tests
        "#"
      end
    else
      "#"
    end
  end
end
