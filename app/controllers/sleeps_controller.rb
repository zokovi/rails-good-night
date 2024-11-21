class SleepsController < ApplicationController
  before_action :set_sleep, only: %i[ show update destroy ]

  # GET /sleeps
  def index
    @sleeps = Sleep.all

    render json: @sleeps
  end

  # GET /sleeps/1
  def show
    render json: @sleep
  end

  # POST /sleeps
  def create
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
