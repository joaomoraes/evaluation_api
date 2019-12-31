class EmployeePolicy < ApplicationPolicy

  private

  def general_access
    user.admin?
  end
end