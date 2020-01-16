# frozen_string_literal: true
FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "test#{n}@test.com" }
    password { 'password' }
    password_confirmation { 'password' }

    trait :admin do
      role { 'admin' } 
      sequence(:email) { |n| "admin#{n}@test.com" }
    end

    trait :employee do
      role { 'employee' }
      sequence(:email) { |n| "employee#{n}@test.com" }
    end
  end
end
