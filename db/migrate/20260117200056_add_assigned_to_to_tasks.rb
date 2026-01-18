class AddAssignedToToTasks < ActiveRecord::Migration[8.1]
  def change
    add_reference :tasks, :assigned_to, null: true, foreign_key: { to_table: :users }
  end
end
