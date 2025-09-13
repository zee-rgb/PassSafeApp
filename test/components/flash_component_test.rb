require "test_helper"

class FlashComponentTest < ViewComponent::TestCase
  def test_component_renders_nothing_when_flash_is_empty
    component = FlashComponent.new(flash: {})
    assert_equal false, component.render?
  end
  
  def test_component_renders_notice_flash
    flash = ActionDispatch::Flash::FlashHash.new
    flash[:notice] = "Test notice message"
    
    component = FlashComponent.new(flash: flash)
    render_inline(component)
    
    assert_selector ".border-green-200.bg-green-50.text-green-800", text: "Test notice message"
  end
  
  def test_component_renders_alert_flash
    flash = ActionDispatch::Flash::FlashHash.new
    flash[:alert] = "Test alert message"
    
    component = FlashComponent.new(flash: flash)
    render_inline(component)
    
    assert_selector ".border-red-200.bg-red-50.text-red-800", text: "Test alert message"
  end
  
  def test_component_renders_other_flash_types
    flash = ActionDispatch::Flash::FlashHash.new
    flash[:info] = "Test info message"
    
    component = FlashComponent.new(flash: flash)
    render_inline(component)
    
    assert_selector ".border-blue-200.bg-blue-50.text-blue-800", text: "Test info message"
  end
  
  def test_component_skips_blank_messages
    flash = ActionDispatch::Flash::FlashHash.new
    flash[:notice] = ""
    flash[:alert] = "This should show"
    
    component = FlashComponent.new(flash: flash)
    render_inline(component)
    
    assert_no_selector ".border-green-200.bg-green-50.text-green-800"
    assert_selector ".border-red-200.bg-red-50.text-red-800", text: "This should show"
  end
end
