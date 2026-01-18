class TaskPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.nil?
        scope.none
      elsif user.admin?
        scope.all
      elsif user.manager?
        # Managers see tasks they created
        scope.where(creator: user)
      else # member
        # Members see tasks assigned to them
        scope.where(assigned_to: user)
      end
    end
  end

  # Everyone can see their own tasks / tasks they are allowed to see
  def index?
    true
  end

  # Show task if admin, creator, or assignee
  def show?
    user.admin? || record.creator == user || record.assigned_to == user
  end

  # Only admin or manager can create tasks
  def create?
    user.admin? || user.manager?
  end

  def new?
    create?
  end

  # Update allowed if admin or creator
  def update?
    user.admin? || record.creator == user
  end

  def edit?
    update?
  end

  # Destroy allowed if admin or creator (member can delete tasks they assigned)
  def destroy?
    user.admin? || record.creator == user
  end

  # Mark complete allowed if admin, creator, or assigned member
  def mark_complete?
    user.admin? || record.creator == user || record.assigned_to == user
  end
end
