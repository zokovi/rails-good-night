class UsersController < ApplicationController
  before_action :set_user, only: %i[ show update destroy ]

  # GET /users
  def index
    limit = params[:limit] || 5
    @users = User.limit(limit)

    render json: @users
  end

  # GET /users/1
  def show
    render json: @user
  end

  # POST /users
  def create
    @user = User.new(user_params)

    if @user.save
      render json: @user, status: :created, location: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /users/1
  def update
    if @user.update(user_params)
      render json: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # DELETE /users/1
  def destroy
    @user.destroy
  end

  # POST /users/:id/follow
  def follow
    @user_to_follow = User.find(params[:id])
    @follow = Follow.new(follower_id: params[:follower_id], following: @user_to_follow)

    if @follow.save
      render json: { message: "Successfully followed user." }, status: :created
    else
      render json: @follow.errors, status: :unprocessable_entity
    end
  end

  # POST /users/:id/unfollow
  def unfollow
    @user_to_unfollow = User.find(params[:id])
    @follow = Follow.find_by(follower_id: params[:follower_id], following: @user_to_unfollow)

    if @follow.destroy
      render json: { message: "Successfully unfollowed user." }, status: :ok
    else
      render json: @follow.errors, status: :unprocessable
    end
  end

  # GET /users/:id/following_sleeps
  def following_sleeps
    @user = User.find(params[:id])
    @following_users_ids = Follow.where(follower_id: @user.id).pluck(:following_id)
    @sleeps = Sleep.where(user_id: @following_users_ids).where.not(sleep_end_time: nil).order(duration_minutes: :desc)

    render json: @sleeps
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render json: { error: "User not found" }, status: :not_found
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(:name)
    end
end
