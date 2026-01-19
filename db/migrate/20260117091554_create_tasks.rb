class CreateTasks < ActiveRecord::Migration[7.1]
  def change
    create_table :tasks do |t|
      t.string      :title,        null: false
      t.text        :description,  null: false
      t.integer     :status,       null: false, default: 0
      t.datetime    :due_date,     null: false
      t.references  :user,         null: false, foreign_key: true          # creator
      t.timestamps
    end
  end
end