class SleepsController < ApplicationController
  before_action :set_sleep, only: %i[ show update destroy ]

  # GET /sleeps
  def index
    limit = params[:limit]
    limit = 5 if limit.nil? || limit.to_i < 1

    user_id = params[:user_id]
    if user_id
      @sleeps = Sleep.where(user_id: user_id).order(created_at: "desc").limit(limit)
    else
      @sleeps = Sleep.all.order(created_at: "desc").limit(limit)
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
    render json: { message: "Sleep record deleted" }
  end

  # POST /sleeps/start_sleep
  def start_sleep
    latest_sleep = find_latest_sleep(start_sleep_params[:user_id])
    if latest_sleep && latest_sleep.sleep_end_time.nil?
      latest_sleep.destroy
    end

    @sleep = Sleep.new(start_sleep_params)
    if @sleep.save
      render json: @sleep, status: :created, location: @sleep
    else
      render json: @sleep.errors, status: :unprocessable_entity
    end
  end

  # POST /sleeps/end_sleep
  def end_sleep
    @sleep = find_latest_sleep(end_sleep_params[:user_id])

    if @sleep.nil? || !@sleep.sleep_end_time.nil?
      render json: { error: "No sleep started for user" }, status: :not_found
      return
    end

    duration_minutes = ((Time.now - @sleep.sleep_start_time) / 60).to_i
    @sleep.update(sleep_end_time: Time.now, duration_minutes: duration_minutes)

    if @sleep.save
      render json: @sleep
    else
      render json: @sleep.errors, status: :unprocessable_entity
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sleep
      @sleep = Sleep.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render json: { error: "Sleep record not found" }, status: :not_found
    end

    # Only allow a list of trusted parameters through.
    def sleep_params
      params.require(:sleep).permit(:user_id, :sleep_start_time, :sleep_end_time, :duration_minutes)
    end

    def start_sleep_params
      params.permit(:user_id).merge(sleep_start_time: Time.now)
    end

    def end_sleep_params
      params.permit(:user_id)
    end

    def find_latest_sleep(user_id)
      Sleep.where(user_id: user_id).order(sleep_start_time: :desc).first
    end
end
