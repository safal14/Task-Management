# app/controllers/tasks_controller.rb
class TasksController < ApplicationController
  include Pundit::Authorization

  before_action :authenticate_user!
  before_action :set_task, only: [:show, :edit, :update, :destroy, :mark_complete]

  def index
    # Different users see different sets of tasks
    if current_user.admin?
      @tasks = Task.all.order(created_at: :desc)
    elsif current_user.manager?
      # Managers see tasks they created + tasks assigned to their team members
      @tasks = Task.where(creator: current_user)
                   .or(Task.where(assigned_to: current_user.team_members))
                   .order(created_at: :desc)
    else
      # Members only see tasks assigned to them
      @tasks = current_user.assigned_tasks.order(created_at: :desc)
    end

    @tasks = @tasks.page(params[:page]).per(10) if defined?(Kaminari) # optional pagination
  end

  def show
    authorize @task
  end

  def new
    @task = Task.new
    authorize @task
  end

  def create
    @task = current_user.created_tasks.build(task_params)
    authorize @task

    if @task.save
      if @task.assigned_to.present?
        TaskMailer.with(task: @task).task_assigned.deliver_later
        flash[:notice] = "Task created and email notification sent to #{@task.assigned_to.full_name}."
      else
        flash[:notice] = "Task created successfully."
      end
      redirect_to @task
    else
      flash.now[:alert] = "Could not create task."
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    authorize @task
  end

  def update
    authorize @task

    if @task.update(task_params)
      # Send notification only if assignee actually changed and new assignee exists
      if @task.assigned_to_id_previously_changed? && @task.assigned_to.present?
        TaskMailer.with(task: @task).task_assigned.deliver_later
        flash[:notice] = "Task updated and reassignment email sent."
      else
        flash[:notice] = "Task updated successfully."
      end
      redirect_to @task
    else
      flash.now[:alert] = "Could not update task."
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @task
    @task.destroy
    flash[:notice] = "Task was successfully deleted."
    redirect_to tasks_path
  end

  # Custom action: mark task as completed
  def mark_complete
    authorize @task, :mark_complete?

    if @task.update(status: :completed)
      # Notify creator if they are not the one who completed it
      if @task.creator.present? && @task.creator != current_user
        TaskMailer.with(task: @task).task_completed.deliver_later
      end
      flash[:notice] = "Task marked as completed."
    else
      flash[:alert] = "Could not mark task as completed."
    end

    redirect_to @task
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