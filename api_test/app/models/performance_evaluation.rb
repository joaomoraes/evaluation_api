class PerformanceEvaluation < ApplicationRecord
  belongs_to :evaluator, class_name: "User", inverse_of: :performance_evaluations_as_evaluator
  belongs_to :target, class_name: "User", inverse_of: :performance_evaluations_as_target

  validates_presence_of :description
  validate :admin_evaluator
  validate :same_evaluator_and_target

  private

  def admin_evaluator
    errors.add(:evaluator, 'needs to be an admin') unless evaluator&.admin?
  end

  def same_evaluator_and_target
    errors.add(:target, "can't be the same as evaluator") unless evaluator != target
  end
end
