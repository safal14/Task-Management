class User < ApplicationRecord
  # Include default devise modules.
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  enum :role, { admin: 0, manager: 1, member: 2 }

  validates :first_name, :last_name, presence: true
  validates :email, presence: true, uniqueness: true

  has_many :created_tasks, class_name: "Task", foreign_key: "user_id"
  has_many :assigned_tasks, class_name: "Task", foreign_key: "assigned_to_id"

  # Add this method
  def full_name
    "#{first_name} #{last_name}"
  end
end
