# frozen_string_literal: true
require 'rails_helper'

RSpec.describe "PerformanceEvaluations/Update", type: :request do
  before do
    create_list(:user, 3, :admin)
    create_list(:user, 5, :employee)
    last_employee = User.employee.last
    first_employee = User.employee.first
    create_list(:performance_evaluation, 3, evaluator: User.admin.last, target: last_employee)
    create_list(:performance_evaluation, 2, evaluator: User.admin.last, target: first_employee)
  end
  let(:first_employee) { User.employee.first }
  let(:last_employee) { User.employee.last }
  let(:performance_evaluation) { last_employee.performance_evaluations_as_target.last }
  let(:response_to_json) { JSON.parse response.body }
  let(:update_performance_evaluation_params) do
      { 
        performance_evaluation: { 
          target_id: first_employee.id,
          description: "#{performance_evaluation.description} added more content" 
        } 
      }
  end

  describe 'signed in' do
    describe 'as admin' do
      let(:admin_user) { create :user, :admin }
      sign_in(:admin_user)

      describe 'updating performance_evaluation with valid params' do

        it 'should respond with success' do
          put performance_evaluation_path(id: performance_evaluation.id), params: update_performance_evaluation_params
          updated_performance_evaluation = PerformanceEvaluation.find(performance_evaluation.id)

          expect(response).to have_http_status(:success)
          expect(response_to_json).not_to be_empty
          expect(updated_performance_evaluation.description).to eq(update_performance_evaluation_params.dig(:performance_evaluation, :description))
          expect(updated_performance_evaluation.target_id).to eq(first_employee.id)
        end
      end

      describe 'updating performance_evaluation with invalid params' do
        describe 'with invalid target_id' do
          let(:invalid_performance_evaluation_params) { update_performance_evaluation_params.dup.tap{ |a| a[:performance_evaluation][:target_id] = User.maximum(:id) + 10 } }
          it 'should respond with unprocessable_entity' do
            put performance_evaluation_path(id: performance_evaluation.id), params: invalid_performance_evaluation_params
            updated_performance_evaluation = PerformanceEvaluation.find(performance_evaluation.id)

            expect(response).to have_http_status(:unprocessable_entity)
            expect(response_to_json).to include('errors')
            expect(updated_performance_evaluation.description).not_to eq(update_performance_evaluation_params.dig(:performance_evaluation, :description))
            expect(updated_performance_evaluation.target_id).to eq(last_employee.id)
          end
        end

        describe 'with target_id equal of the current_user' do
          let(:invalid_performance_evaluation_params) { update_performance_evaluation_params.dup.tap{ |a| a[:performance_evaluation][:target_id] = admin_user.id } }
          it 'should respond with unprocessable_entity' do
            put performance_evaluation_path(id: performance_evaluation.id), params: invalid_performance_evaluation_params
            updated_performance_evaluation = PerformanceEvaluation.find(performance_evaluation.id)

            expect(response).to have_http_status(:unprocessable_entity)
            expect(response_to_json).to include('errors')
            expect(updated_performance_evaluation.description).not_to eq(update_performance_evaluation_params.dig(:performance_evaluation, :description))
            expect(updated_performance_evaluation.target_id).to eq(last_employee.id)
          end
        end
      end
    end

    describe 'as employee' do
      let(:employee_user) { create :user, :employee }
      sign_in(:employee_user)

      it 'should respond with unauthorized' do
        put performance_evaluation_path(id: performance_evaluation.id), params: update_performance_evaluation_params
        updated_performance_evaluation = PerformanceEvaluation.find(performance_evaluation.id)

        expect(response).to have_http_status(:unauthorized)
        expect(response_to_json).to include('errors')
        expect(response_to_json['errors']).to include(I18n.t('controllers.api.v1.base.user_not_authorized'))
        expect(updated_performance_evaluation.description).not_to eq(update_performance_evaluation_params.dig(:performance_evaluation, :description))
        expect(updated_performance_evaluation.target_id).to eq(last_employee.id)
      end
    end
  end

  describe 'signed out' do
    it 'should respond with unauthorized' do
      put performance_evaluation_path(id: performance_evaluation.id), params: update_performance_evaluation_params
      updated_performance_evaluation = PerformanceEvaluation.find(performance_evaluation.id)

      expect(response).to have_http_status(:unauthorized)
      expect(response_to_json).to include('errors')
      expect(response_to_json['errors']).not_to be_empty
      expect(updated_performance_evaluation.description).not_to eq(update_performance_evaluation_params.dig(:performance_evaluation, :description))
      expect(updated_performance_evaluation.target_id).to eq(last_employee.id)
    end
  end
end