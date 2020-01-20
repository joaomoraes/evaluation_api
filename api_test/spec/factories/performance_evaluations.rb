# frozen_string_literal: true
FactoryBot.define do
  factory :performance_evaluation do
    sequence(:description) { |n| "<br/> Description #{n} Test" }
    association :evaluator, factory: [:user, :admin]
    association :target, factory: [:user, :employee]
  end
end