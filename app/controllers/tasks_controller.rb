class TasksController < ApplicationController
  include Pundit::Authorization

  before_action :authenticate_user!
  before_action :set_task, only: [:show, :edit, :update, :destroy, :mark_complete]

  after_action :verify_authorized, except: :index
  after_action :verify_policy_scoped, only: :index

  # ---------- INDEX ----------
  def index
    @tasks = policy_scope(Task).order(created_at: :desc)
  end

  # ---------- SHOW ----------
  def show
    authorize @task
  end

  # ---------- NEW ----------
  def new
    @task = Task.new
    @members = User.member
    authorize @task
  end

  # ---------- CREATE ----------
def create
  @task = Task.new(task_params)
  @task.creator = current_user
  authorize @task

  if @task.save
    if @task.assigned_to.present?
      TaskMailer.with(task: @task).assigned_email.deliver_later
      redirect_to @task, notice: "Task created and assigned successfully."
    else
      redirect_to @task, notice: "Task created successfully."
    end
  else
    @members = User.member
    render :new, status: :unprocessable_entity
  end
end


  # ---------- EDIT ----------
  def edit
    @members = User.member
    authorize @task
  end

  # ---------- UPDATE ----------
  def update
    authorize @task

    assignee_changed = @task.assigned_to_id != task_params[:assigned_to_id].to_i

    if @task.update(task_params)
      if assignee_changed && @task.assigned_to.present?
        TaskMailer.assigned_email(@task).deliver_later
        notice = "Task updated and reassigned."
      else
        notice = "Task updated successfully."
      end
      redirect_to @task, notice: notice
    else
      @members = User.member
      render :edit, status: :unprocessable_entity
    end
  end

  # ---------- DESTROY ----------
  def destroy
    authorize @task
    @task.destroy
    redirect_to tasks_path, notice: "Task deleted successfully."
  end

  # ---------- MARK COMPLETE ----------
def mark_complete
  authorize @task, :mark_complete?

  if @task.update(status: :completed)
    # Send email to creator if current user is not the creator
    if @task.creator != current_user
      TaskMailer.with(task: @task, completed_by: current_user).completed_email.deliver_later
    end
    redirect_to @task, notice: "Task marked as completed."
  else
    redirect_to @task, alert: "Could not complete task."
  end
end


  private

  def set_task
    @task = Task.find(params[:id])
  end

  def task_params
    params.require(:task).permit(
      :title,
      :description,
      :due_date,
      :status,
      :assigned_to_id
    )
  end
end
