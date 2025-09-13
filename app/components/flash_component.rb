class FlashComponent < ViewComponent::Base
  def initialize(flash:)
    @flash = flash
  end

  def render?
    @flash.present? && @flash.any? { |_, message| message.present? }
  end

  private

  def flash_class(type)
    case type.to_s
    when "notice", "success"
      "border-green-200 bg-green-50 text-green-800"
    when "alert", "error"
      "border-red-200 bg-red-50 text-red-800"
    else
      "border-blue-200 bg-blue-50 text-blue-800"
    end
  end
end
