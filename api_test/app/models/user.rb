# frozen_string_literal: true

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  include DeviseTokenAuth::Concerns::User

  enum role: { admin: 0, employee: 1 }
  has_many :performance_evaluations_as_evaluator, class_name: "PerformanceEvaluation", foreign_key: "evaluator_id", inverse_of: :evaluator, dependent: :destroy
  has_many :performance_evaluations_as_target, class_name: "PerformanceEvaluation", foreign_key: "target_id", inverse_of: :target, dependent: :destroy
end
