class SleepsController < ApplicationController
  before_action :set_sleep, only: %i[ show update destroy ]

  # GET /sleeps
  def index
    user_id = params[:user_id]
    limit = params[:limit]
    limit = 5 if limit == nil || limit.to_i < 1

    if user_id
      @sleeps = Sleep.where(user_id: user_id).limit(limit)
    else
      @sleeps = Sleep.all.limit(limit)
    end

    render json: @sleeps
  end

  # GET /sleeps/1
  def show
    render json: @sleep
  end

  # POST /sleeps
  def create
    # if adding sleep manually (manual track)
    # make sure that all required parameters are present
    missing_params = []
    %i[user_id sleep_start_time sleep_end_time duration_minutes].each do |param|
      missing_params << param unless params[:sleep].key?(param)
    end

    unless missing_params.empty?
      render json: { error: "Missing parameters: #{missing_params.join(', ')}" }, status: :unprocessable_entity
      return
    end

    @sleep = Sleep.new(sleep_params)

    if @sleep.save
      render json: @sleep, status: :created, location: @sleep
    else
      render json: @sleep.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /sleeps/1
  def update
    if @sleep.update(sleep_params)
      render json: @sleep
    else
      render json: @sleep.errors, status: :unprocessable_entity
    end
  end

  # DELETE /sleeps/1
  def destroy
    @sleep.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sleep
      @sleep = Sleep.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def sleep_params
      params.require(:sleep).permit(:user_id, :sleep_start_time, :sleep_end_time, :duration_minutes)
    end
end
