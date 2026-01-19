# Preview all emails at http://localhost:3000/rails/mailers/task_mailer
class TaskMailerPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/task_mailer/task_assigned
  def task_assigned
    TaskMailer.task_assigned
  end

  # Preview this email at http://localhost:3000/rails/mailers/task_mailer/task_completed
  def task_completed
    TaskMailer.task_completed
  end
end
