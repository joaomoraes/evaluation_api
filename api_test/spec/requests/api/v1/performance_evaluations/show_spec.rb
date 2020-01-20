# frozen_string_literal: true
require 'rails_helper'

RSpec.describe "PerformanceEvaluations/Show", type: :request do
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

  describe 'signed in' do
    describe 'as admin' do
      let(:admin_user) { create :user, :admin }
      sign_in(:admin_user)

      describe 'requesting a valid performance_evaluations id' do

        it 'should respond with success' do
          get performance_evaluation_path(id: performance_evaluation.id)
          expect(response).to have_http_status(:success)
          expect(response_to_json).not_to be_empty
        end
      end

      describe 'requesting an invalid performance_evaluations id' do
        let(:invalid_performance_evaluation_id) { PerformanceEvaluation.maximum(:id) + 10 }
        it 'should respond with not_found' do
          get performance_evaluation_path(id: invalid_performance_evaluation_id)
          expect(response).to have_http_status(:not_found)
          expect(response_to_json).to include('errors')
          expect(response_to_json['errors']).to include(I18n.t('controllers.api.v1.performance_evaluations.get_performance_evaluation'))
        end
      end
    end

    describe 'as employee' do
      describe 'requesting a performance_evaluations id with him as target' do
        sign_in(:last_employee)

        it 'should respond with success' do
          get performance_evaluation_path(id: performance_evaluation.id)

          expect(response).to have_http_status(:success)
          expect(response_to_json).not_to be_empty
        end
      end

      describe 'requesting a performance_evaluations id with him not as target' do
        sign_in(:first_employee)

        it 'should respond with unauthorized' do
          get performance_evaluation_path(id: performance_evaluation.id)

          expect(response).to have_http_status(:unauthorized)
          expect(response_to_json).to include('errors')
          expect(response_to_json['errors']).to include(I18n.t('controllers.api.v1.base.user_not_authorized'))
        end
      end
    end
  end

  describe 'signed out' do
    it 'should respond with unauthorized' do
      get performance_evaluation_path(id: performance_evaluation.id)
      expect(response).to have_http_status(:unauthorized)
      expect(response_to_json).to include('errors')
      expect(response_to_json['errors']).not_to be_empty
    end
  end
end