require "test_helper"

class NavbarComponentTest < ViewComponent::TestCase
  include ActionView::Helpers::TranslationHelper
  
  # Mock the component's helpers method for testing
  class TestNavbarComponent < NavbarComponent
    def helpers
      MockHelpers.new
    end
  end
  
  # Simple mock for helpers
  class MockHelpers
    def url_for(options)
      "#"
    end
    
    def respond_to?(method_name)
      method_name == :url_for || super
    end
  end
  
  setup do
    # No setup needed
  end

  def test_renders_guest_menu_when_not_signed_in
    component = TestNavbarComponent.new(current_user: nil)
    render_inline(component)
    
    # Guest menu links should be present
    assert_link t("nav.sign_in")
    assert_link t("nav.sign_up")
    
    # User menu elements should not be present
    assert_no_link t("nav.dashboard")
    assert_no_text t("nav.signed_in_as")
  end
  
  def test_renders_user_menu_when_signed_in
    user = User.new(email: "test@example.com")
    component = TestNavbarComponent.new(current_user: user)
    render_inline(component)
    
    # User menu elements should be present
    assert_link t("nav.dashboard")
    assert_link t("nav.profile")
    assert_link t("nav.sign_out")
    
    # Should show user email
    assert_text "test@example.com"
    
    # Guest elements should not be present
    assert_no_link t("nav.sign_up")
  end
  
  def test_language_dropdown_is_always_present
    # Test with user not signed in
    component = TestNavbarComponent.new(current_user: nil)
    render_inline(component)
    
    # Should show current locale and language options
    assert_text I18n.locale.to_s.upcase
    assert_text "English (EN)"
    assert_text "Español (ES)"
  end
end
