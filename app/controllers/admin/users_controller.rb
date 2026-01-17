# app/controllers/admin/users_controller.rb
class Admin::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin!   # Add your admin check here (e.g. current_user.admin?)

  before_action :set_user, only: [:edit, :update, :destroy]

  def index
    @users = User.all.order(created_at: :desc)
    @users = @users.page(params[:page]).per(10) if defined?(Kaminari) # optional
  end

  # NEW: Edit action (renders the edit form)
  def edit
    # @user is already set by before_action
  end

  # NEW: Update action (for changing role, etc.)
  def update
    if @user.update(user_params)
      flash[:notice] = "User updated successfully."
      redirect_to admin_users_path
    else
      flash.now[:alert] = "Failed to update user."
      render :edit, status: :unprocessable_entity
    end
  end

  # NEW: Destroy action
  def destroy
    @user.destroy
    flash[:notice] = "User was successfully deleted."
    redirect_to admin_users_path
  end

  # Your invite action (from earlier)
  def invite_manager
    @user = User.new(
      email: params[:email],
      first_name: params[:first_name],
      last_name: params[:last_name],
      role: :manager
    )

    @user.invite!(current_user)

    if @user.errors.empty?
      flash[:notice] = "Invitation sent to #{@user.email}"
    else
      flash[:alert] = "Failed to send invitation: #{@user.errors.full_messages.to_sentence}"
    end

    redirect_to admin_users_path
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :role)
    # Add more fields if needed, but be careful with role changes
  end

  def require_admin!
    redirect_to root_path, alert: "Admins only!" unless current_user&.admin?
  end
end