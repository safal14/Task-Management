class User < ApplicationRecord
  # Include default devise modules.
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  enum :role, {
    admin:   0,
    manager: 1,
    member:  2
  }

  validates :first_name, :last_name, presence: true

  # We'll add associations later
end