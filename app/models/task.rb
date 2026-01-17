class Task < ApplicationRecord
  belongs_to :creator, class_name: "User", foreign_key: "user_id"
  belongs_to :assigned_to, class_name: "User", optional: true

  enum status: {
    pending:   0,
    completed: 1
  }, _default: :pending

  validates :title, presence: true
  validates :description, presence: true
  validates :due_date, presence: true
  validates :due_date, comparison: { greater_than: -> { Time.zone.now } },
                       if: -> { due_date.present? }

  validate :assigned_to_must_be_member

  private

  def assigned_to_must_be_member
    return unless assigned_to
    return if assigned_to.member?
    errors.add(:assigned_to, "must be a member (not admin or manager)")
  end
end