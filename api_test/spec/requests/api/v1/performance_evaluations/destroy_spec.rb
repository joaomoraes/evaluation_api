# frozen_string_literal: true
require 'rails_helper'

RSpec.describe "PerformanceEvaluations/Destroy", type: :request do
  before do
    create_list(:user, 2, :admin)
    create_list(:user, 3, :employee)
    last_employee = User.employee.last
    first_employee = User.employee.first
    create_list(:performance_evaluation, 2, evaluator: User.admin.last, target: last_employee)
    create_list(:performance_evaluation, 2, evaluator: User.admin.last, target: first_employee)
  end
  let(:performance_evaluation_id) { PerformanceEvaluation.last.id }
  let(:response_to_json) { JSON.parse response.body }

  describe 'signed in' do
    describe 'as admin' do
      let(:admin_user) { create :user, :admin }
      sign_in(:admin_user)

      describe 'destroy valid performance_evaluation id' do
        it 'should respond with success' do
          delete performance_evaluation_path(id: performance_evaluation_id)
          expect(response).to have_http_status(:success)
          expect(response_to_json).not_to be_empty
          expect{ PerformanceEvaluation.find(performance_evaluation_id) }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end

      describe 'destroy invalid performance_evaluation id' do
        it 'should respond with not_found' do
          delete performance_evaluation_path(id: PerformanceEvaluation.maximum(:id) + 1)
          expect(response).to have_http_status(:not_found)
          expect(response_to_json).to include('errors')
        end
      end
    end

    describe 'as employee target of the performance_evaluation' do
      let(:employee_user) { PerformanceEvaluation.find(performance_evaluation_id).target }
      sign_in(:employee_user)

      it 'should respond with unauthorized' do
        delete performance_evaluation_path(id: performance_evaluation_id)

        expect(response).to have_http_status(:unauthorized)
        expect(response_to_json).to include('errors')
        expect(response_to_json['errors']).to include(I18n.t('controllers.api.v1.base.user_not_authorized'))
        expect{ PerformanceEvaluation.find(performance_evaluation_id) }.not_to raise_error
      end
    end
  end

  describe 'signed out' do
    it 'should respond with unauthorized' do
      delete performance_evaluation_path(id: performance_evaluation_id)
      expect(response).to have_http_status(:unauthorized)
      expect(response_to_json).to include('errors')
      expect(response_to_json['errors']).not_to be_empty
      expect{ PerformanceEvaluation.find(performance_evaluation_id) }.not_to raise_error
    end
  end
end