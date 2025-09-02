class EntriesController < ApplicationController
  before_action :authenticate_user!

  def index
    @entries = current_user.entries
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

  private

  def entry_params
    params.expect(entry: [ :name, :url, :username, :password ])
  end
end
