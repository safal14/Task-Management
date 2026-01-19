class DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
    if current_user.admin?
      @tasks = Task.all.order(created_at: :desc)
    elsif current_user.manager?
      @tasks = Task.where(creator: current_user)
                   .or(Task.where(assigned_to: current_user))
                   .order(created_at: :desc)
    else
      @tasks = current_user.assigned_tasks.order(created_at: :desc)
    end
  end
end
