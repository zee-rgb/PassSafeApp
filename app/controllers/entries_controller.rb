class EntriesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_entry, only: [ :show, :edit, :update, :destroy ]

  def index
    @entries = current_user.entries
  end

  def show
  end

  def new
    @entry = Entry.new
  end

  def create
    @entry = current_user.entries.new(entry_params)

    if @entry.save
      redirect_to root_path, notice: "Entry created successfully"
    else
      render :new, status: :unprocessable_entity, alert: "Entry creation failed"
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

  private

  def entry_params
    params.expect(entry: [ :name, :url, :username, :password ])
  end

  def set_entry
    @entry = current_user.entries.find_by(id: params[:id])
    return if @entry.present?

    redirect_to entries_path, alert: "Entry not found"
  end
end
