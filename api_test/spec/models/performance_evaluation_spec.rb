# frozen_string_literal: true
require 'rails_helper'

RSpec.describe PerformanceEvaluation, type: :model do
  subject { described_class }
  describe "when creating" do
    it "doesn't allow non-admin as evaluator" do
      performance_evaluation = build(:performance_evaluation, evaluator: build(:user, :employee))
      expect(performance_evaluation).not_to be_valid
      expect(performance_evaluation.errors.count).to eq(1)
      expect(performance_evaluation.errors).to include(:evaluator)
    end

    it "doesn't allow evaluator and target to be the same" do
      evaluator = build(:user, :admin)
      performance_evaluation = build(:performance_evaluation, evaluator: evaluator, target: evaluator)
      expect(performance_evaluation).not_to be_valid
      expect(performance_evaluation.errors.count).to eq(1)
      expect(performance_evaluation.errors).to include(:target)
    end

    it { expect(build(:performance_evaluation, evaluator: nil)).not_to be_valid }
    it { expect(build(:performance_evaluation, target: nil)).not_to be_valid }
    it { expect(build(:performance_evaluation, description: nil)).not_to be_valid }
  end
end
