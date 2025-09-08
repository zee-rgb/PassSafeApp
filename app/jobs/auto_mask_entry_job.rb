class AutoMaskEntryJob < ApplicationJob
  queue_as :default

  # For testing with assert_enqueued_with
  include ActiveJob::TestHelper if Rails.env.test?

  def perform(entry_id, field)
    entry = Entry.find_by(id: entry_id)
    return unless entry

    frame_id = "entry_#{entry.id}_#{field}_reveal"

    # Build replacement content as a turbo-frame with the masked partial inside
    inner = ApplicationController.render(
      partial: "entries/reveals/masked_#{field}",
      formats: :html,
      locals: { entry: entry }
    )

    frame_html = ApplicationController.render(
      inline: "<turbo-frame id='#{frame_id}'>#{inner}</turbo-frame>",
      formats: :html
    )

    Turbo::StreamsChannel.broadcast_replace_to(
      frame_id,
      target: frame_id,
      content: frame_html
    )
  end
end
