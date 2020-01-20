# frozen_string_literal: true
require 'rails_helper'

RSpec.describe "PerformanceEvaluations/Index", type: :request do
  before do
    create_list(:user, 2, :admin)
    create_list(:user, 4, :employee)
    last_employee = User.employee.last
    first_employee = User.employee.first
    create_list(:performance_evaluation, 3, evaluator: User.admin.last, target: last_employee)
    create_list(:performance_evaluation, 2, evaluator: User.admin.last, target: first_employee)
  end
  let(:response_to_json) { JSON.parse response.body }

  describe 'signed in' do
    describe 'as admin' do
      let(:admin_user) { create :user, :admin }
      sign_in(:admin_user)

      it 'should respond with success' do
        get performance_evaluations_path

        expect(response).to have_http_status(:success)
        expect(response_to_json.count).to eq(5)
      end
    end

    describe 'as employee' do
      let(:employee_user) { create :user, :employee }
      sign_in(:employee_user)

      it "should respond with success and with only it's own performance evaluations" do
        create_list(:performance_evaluation, 4, evaluator: User.admin.last, target: employee_user)
        get performance_evaluations_path

        expect(response).to have_http_status(:success)
        expect(response_to_json.count).to eq(4)
      end

      it "should respond with success and empty if there are no performance evaluations for the employee" do
        get performance_evaluations_path

        expect(response).to have_http_status(:success)
        expect(response_to_json.count).to eq(0)
      end
    end
  end

  describe 'signed out' do
    it 'should respond with unauthorized' do
      get performance_evaluations_path
      expect(response).to have_http_status(:unauthorized)
      expect(response_to_json).to include('errors')
      expect(response_to_json['errors']).not_to be_empty
    end
  end
end