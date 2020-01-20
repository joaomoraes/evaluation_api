# frozen_string_literal: true
require 'rails_helper'

RSpec.describe "PerformanceEvaluations/Create", type: :request do
  before do
    create_list(:user, 2, :admin)
    create_list(:user, 2, :employee)
  end
  let(:response_to_json) { JSON.parse response.body }
  let(:target_id) { User.employee.last.id }
  let(:create_performance_evaluation_params) do
    {
      performance_evaluation: { 
        target_id: target_id,
        description: "<br/> Test Description <br/>"
      }
    }
 end

  describe 'signed in' do
    describe 'as admin' do
      let(:admin_user) { create :user, :admin }
      sign_in(:admin_user)

      describe 'creating a valid performance evaluation' do

        it 'should respond with success' do
          post performance_evaluations_path, params: create_performance_evaluation_params
          expect(response).to have_http_status(:success)
          expect(response_to_json).not_to be_empty
        end
      end

      describe 'creating an invalid performance evaluation' do
        describe 'without target_id' do
          let(:invalid_performance_evaluation_params) { create_performance_evaluation_params.dup.tap{ |a| a[:performance_evaluation].delete(:target_id) } }
          it 'should respond with unprocessable_entity' do
            post performance_evaluations_path, params: invalid_performance_evaluation_params
            expect(response).to have_http_status(:unprocessable_entity)
            expect(response_to_json).to include('errors')
          end
        end

        describe 'invalid target_id' do
          let(:invalid_performance_evaluation_params) { create_performance_evaluation_params.dup.tap{ |a| a[:performance_evaluation][:target_id] = User.maximum(:id) + 10 } }
          it 'should respond with unprocessable_entity' do
            post performance_evaluations_path, params: invalid_performance_evaluation_params
            expect(response).to have_http_status(:unprocessable_entity)
            expect(response_to_json).to include('errors')
          end
        end

        describe 'without description' do
          let(:invalid_performance_evaluation_params) { create_performance_evaluation_params.dup.tap{ |a| a[:performance_evaluation].delete(:description) } }
          it 'should respond with unprocessable_entity' do
            post performance_evaluations_path, params: invalid_performance_evaluation_params
            expect(response).to have_http_status(:unprocessable_entity)
            expect(response_to_json).to include('errors')
          end
        end

        describe 'target equal to current_user' do
          let(:invalid_performance_evaluation_params) { create_performance_evaluation_params.tap{ |a| a[:performance_evaluation][:target_id] = admin_user.id } }
          it 'should respond with unprocessable_entity' do
            post performance_evaluations_path, params: invalid_performance_evaluation_params
            expect(response).to have_http_status(:unprocessable_entity)
            expect(response_to_json).to include('errors')
          end
        end
      end
    end

    describe 'as employee' do
      let(:employee_user) { create :user, :employee }
      sign_in(:employee_user)

      it 'should respond with unauthorized' do
        post performance_evaluations_path, params: create_performance_evaluation_params

        expect(response).to have_http_status(:unauthorized)
        expect(response_to_json).to include('errors')
        expect(response_to_json['errors']).to include(I18n.t('controllers.api.v1.base.user_not_authorized'))
      end
    end
  end

  describe 'signed out' do
    it 'should respond with unauthorized' do
      post performance_evaluations_path, params: create_performance_evaluation_params
      expect(response).to have_http_status(:unauthorized)
      expect(response_to_json).to include('errors')
      expect(response_to_json['errors']).not_to be_empty
    end
  end
end