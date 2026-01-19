# app/mailers/task_mailer.rb
class TaskMailer < ApplicationMailer
  default from: "no-reply@taskapp.com"

  # ------------------- New Task Assigned -------------------
  def assigned_email
    @task = params[:task]
    return unless @task.assigned_to.present?

    @assigned_user = @task.assigned_to

    mail(
      to: @assigned_user.email,
      subject: "New Task Assigned: #{@task.title}"
    )
  end

  # ------------------- Task Updated -------------------
  def update_email
    @task = params[:task]
    return unless @task.creator.present?

    @creator = @task.creator

    mail(
      to: @creator.email,
      subject: "Update on Task: #{@task.title}"
    )
  end

  # ------------------- Task Completed -------------------
  def completed_email
    @task = params[:task]
    @completed_by = params[:completed_by]
    return unless @task.creator.present?

    @creator = @task.creator

    mail(
      to: @creator.email,
      subject: "Task Completed: #{@task.title}"
    )
  end
end
