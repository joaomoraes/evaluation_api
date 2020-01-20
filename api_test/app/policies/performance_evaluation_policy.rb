class PerformanceEvaluationPolicy < ApplicationPolicy

  def index?
    user.admin? || user.employee?
  end

  def show?
    return true if user.admin?
    user.employee? && record.target == user
  end

  private

  def general_access
    user.admin?
  end

end