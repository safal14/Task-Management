class TaskPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.nil?
        scope.none
      elsif user.admin?
        scope.all
      elsif user.manager?
        # For now: only own created tasks (we improve later)
        scope.where(creator: user)
      else # member
        scope.where(assigned_to: user)
      end
    end
  end

  def index?
    true   # everyone can see their own dashboard/tasks
  end

  def show?
    user.admin? || record.creator == user || record.assigned_to == user
  end

  def create?
    user.admin? || user.manager?
  end

  def new?
    create?
  end

  def update?
    user.admin? || record.creator == user
  end

  def edit?
    update?
  end

  def destroy?
    user.admin? || record.creator == user
  end

  def mark_complete?
    user.admin? || record.creator == user || record.assigned_to == user
  end
end