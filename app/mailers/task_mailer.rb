class TaskMailer < ApplicationMailer
  def task_assigned(task)
    @task = task
    @assigned_user = task.assigned_to
    @creator = task.creator

    mail(
      to: @assigned_user.email,
      subject: "New Task Assigned: #{@task.title}"
    )
  end

  def task_completed(task)
    @task = task
    @creator = task.creator
    @completed_by = task.assigned_to  # or whoever marked it done

    mail(
      to: @creator.email,
      subject: "Task Completed: #{@task.title}"
    )
  end
end