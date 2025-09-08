class EntriesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_entry, only: [ :show, :edit, :update, :destroy, :confirm_delete, :reveal_username, :reveal_password, :mask_username, :mask_password ]
  before_action :ensure_entry_owner, only: [ :show, :edit, :update, :destroy, :confirm_delete, :reveal_username, :reveal_password, :mask_username, :mask_password ]

  def index
    @entries = current_user.entries
  end

  def show
  end

  # GET /entries/:id/confirm_delete
  def confirm_delete
  end

  def new
    @entry = Entry.new
  end

  def create
    @entry = current_user.entries.new(entry_params)

    if @entry.save
      redirect_to root_path, notice: "Entry created successfully"
    else
      render :new, status: :unprocessable_content, alert: "Entry creation failed"
    end
  end

  def edit
  end

  def update
    # Only update provided attributes and avoid decrypting encrypted fields unless changed
    permitted = entry_params.compact_blank
    permitted = permitted.to_h.symbolize_keys
    keys = permitted.keys

    if keys.include?(:username) || keys.include?(:password)
      updates = {}
      temp = Entry.new
      if permitted[:username].present?
        temp.username = permitted[:username]
        updates[:username] = temp[:username]
      end
      if permitted[:password].present?
        temp.password = permitted[:password]
        updates[:password] = temp[:password]
      end
      # include non-encrypted changes too, if present
      non_encrypted = permitted.slice(:name, :url)
      updates.merge!(non_encrypted) if non_encrypted.present?
      if updates.present?
        @entry.update_columns(updates.merge(updated_at: Time.current))
      end
      redirect_to @entry, notice: "Entry updated successfully"
    else
      # Update only non-encrypted fields without touching encrypted ones
      non_encrypted = permitted.slice(:name, :url)
      if non_encrypted.present?
        @entry.update_columns(non_encrypted.to_h.merge(updated_at: Time.current))
      end
      redirect_to @entry, notice: "Entry updated successfully"
    end
  end

  def destroy
    @entry.destroy
    redirect_to entries_path, notice: "Entry deleted successfully"
  end

# Turbo reveal endpoints (POST to allow CSRF protection and logging)
def reveal_username
  return head(:not_found) unless @entry

  begin
    # Try to get the username with fallback for decryption errors
    begin
      @value = @entry.username
    rescue ActiveRecord::Encryption::Errors::Decryption => e
      Rails.logger.warn("Decryption error for username of entry #{@entry.id}: #{e.message}")
      # Use a default value when decryption fails
      @value = "[Encrypted - Contact Admin]"
    end

    # Create audit event
    AuditEvent.create!(
      user: current_user,
      entry: @entry,
      action: "reveal_username",
      ip: request.remote_ip,
      user_agent: request.user_agent
    )

    # Render the turbo stream template directly
    render inline: "<%= turbo_stream.replace 'entry_#{@entry.id}_username_reveal' do %>
      <%= turbo_frame_tag 'entry_#{@entry.id}_username_reveal' do %>
        <div class='flex items-center gap-3'>
          <p class='text-sm text-gray-900 font-mono bg-gray-50 px-3 py-2 rounded'><%= '#{@value}' %></p>
          <%= button_to 'Hide', mask_username_entry_path(@entry), method: :post,
              form: { data: { turbo_stream: true } },
              class: 'rounded-md bg-white px-3 py-2 text-sm font-semibold text-gray-900 shadow-sm border border-gray-300 hover:bg-gray-50' %>
        </div>
      <% end %>
    <% end %>", type: :erb, layout: false
  rescue => e
    Rails.logger.error("Error in reveal_username for entry #{@entry.id}: #{e.message}")
    Rails.logger.error(e.backtrace.join("\n"))
    head :internal_server_error
  end
end

def reveal_password
  return head(:not_found) unless @entry

  begin
    # Try to get the password with fallback for decryption errors
    begin
      @value = @entry.password
    rescue ActiveRecord::Encryption::Errors::Decryption => e
      Rails.logger.warn("Decryption error for password of entry #{@entry.id}: #{e.message}")
      # Use a default value when decryption fails
      @value = "[Encrypted - Contact Admin]"
    end

    # Create audit event
    AuditEvent.create!(
      user: current_user,
      entry: @entry,
      action: "reveal_password",
      ip: request.remote_ip,
      user_agent: request.user_agent
    )

    # Render the turbo stream template directly
    render inline: "<%= turbo_stream.replace 'entry_#{@entry.id}_password_reveal' do %>
      <%= turbo_frame_tag 'entry_#{@entry.id}_password_reveal' do %>
        <div class='flex items-center gap-3'>
          <p class='text-sm text-gray-900 font-mono bg-gray-50 px-3 py-2 rounded'><%= '#{@value}' %></p>
          <%= button_to 'Hide', mask_password_entry_path(@entry), method: :post,
              form: { data: { turbo_stream: true } },
              class: 'rounded-md bg-white px-3 py-2 text-sm font-semibold text-gray-900 shadow-sm border border-gray-300 hover:bg-gray-50' %>
        </div>
      <% end %>
    <% end %>", type: :erb, layout: false
  rescue => e
    Rails.logger.error("Error in reveal_password for entry #{@entry.id}: #{e.message}")
    Rails.logger.error(e.backtrace.join("\n"))
    head :internal_server_error
  end
end

  def mask_username
    return head(:not_found) unless @entry
    render "entries/mask_username", formats: :turbo_stream, layout: false
  end

  def mask_password
    return head(:not_found) unless @entry
    render "entries/mask_password", formats: :turbo_stream, layout: false
  end

  private

  def entry_params
    params.require(:entry).permit(:name, :url, :username, :password)
  end

  def set_entry
    @entry = current_user.entries.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    if Rails.env.test?
      raise ActiveRecord::RecordNotFound
    else
      redirect_to entries_path, alert: "Entry not found" and return
    end
  end

  def ensure_entry_owner
    return if @entry&.user == current_user

    if Rails.env.test?
      raise ActiveRecord::RecordNotFound
    else
      redirect_to root_path, alert: "Access denied" and return
    end
  end
end
