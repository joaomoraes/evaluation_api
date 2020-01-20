# frozen_string_literal: true
class Api::V1::PerformanceEvaluationsController < Api::V1::BaseController
  before_action :authenticate_user!
  before_action :get_performance_evaluation, only: [:show, :update, :destroy]
  before_action :authorize_performance_evaluation!

  def index
    performance_evaluations = current_user.admin? ? PerformanceEvaluation.all : current_user.performance_evaluations_as_target
    render json: performance_evaluations
  end

  def create
    @performance_evaluation = PerformanceEvaluation.create(performance_evaluation_params.merge(evaluator: current_user))
    display_saved_performance_evaluation
  end

  def show
    render json: @performance_evaluation
  end

  def update
    @performance_evaluation.update performance_evaluation_params.merge(evaluator: current_user)
    display_saved_performance_evaluation
  end

  def destroy
    @performance_evaluation.destroy
    render json: @performance_evaluation
  end

  private

  def display_saved_performance_evaluation
    if @performance_evaluation.valid?
      render json: @performance_evaluation
    else
      error_message message: @performance_evaluation.errors.messages, status: :unprocessable_entity
    end
  end

  def get_performance_evaluation
    begin
      @performance_evaluation = PerformanceEvaluation.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      error_message message: i18n_scoped(key:'get_performance_evaluation'), status: :not_found
    end
  end

  def authorize_performance_evaluation!
    @performance_evaluation ||= PerformanceEvaluation
    authorize @performance_evaluation, policy_class: PerformanceEvaluationPolicy
  end

  def performance_evaluation_params
    params.require(:performance_evaluation).permit(:description, :target_id)
  end

end
