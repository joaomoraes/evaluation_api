# frozen_string_literal: true
require 'rails_helper'

RSpec.describe "Employees/Create", type: :request do
  before do
    create_list(:user, 3, :admin)
    create_list(:user, 5, :employee)
  end
  let(:employee) { User.employee.last }
  let(:response_to_json) { JSON.parse response.body }
  let(:create_employee_params) do
    { 
      employee: { 
        email: 'testemail@testemail.com', 
        name: 'Test Name', 
        password: 'pass123', 
        password_confirmation: 'pass123' 
      } 
    }
 end

  describe 'signed in' do
    describe 'as admin' do
      let(:admin_user) { create :user, :admin }
      sign_in(:admin_user)

      describe 'creating a valid employee' do

        it 'should respond with success' do
          post employees_path, params: create_employee_params
          expect(response).to have_http_status(:success)
          expect(response_to_json).not_to be_empty
        end

        describe 'without password' do
          let(:invalid_employee_params) { create_employee_params.dup.tap{ |a| [:password, :password_confirmation].each{|key| a[:employee].delete(key)} } }
          it 'should respond with success' do
            post employees_path, params: create_employee_params
            expect(response).to have_http_status(:success)
            expect(response_to_json).not_to be_empty
          end
        end
      end

      describe 'creating an invalid employee' do
        describe 'without email' do
          let(:invalid_employee_params) { create_employee_params.dup.tap{ |a| a[:employee].delete(:email) } }
          it 'should respond with unprocessable_entity' do
            post employees_path, params: invalid_employee_params
            expect(response).to have_http_status(:unprocessable_entity)
            expect(response_to_json).to include('errors')
          end
        end

        describe 'without password with password_confirmation' do
          let(:invalid_employee_params) { create_employee_params.dup.tap{ |a| a[:employee].delete(:password) } }
          it 'should respond with unprocessable_entity' do
            post employees_path, params: invalid_employee_params
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
        post employees_path, params: create_employee_params

        expect(response).to have_http_status(:unauthorized)
        expect(response_to_json).to include('errors')
        expect(response_to_json['errors']).to include(I18n.t('controllers.api.v1.base.user_not_authorized'))
      end
    end
  end

  describe 'signed out' do
    it 'should respond with unauthorized' do
      post employees_path, params: create_employee_params
      expect(response).to have_http_status(:unauthorized)
      expect(response_to_json).to include('errors')
      expect(response_to_json['errors']).not_to be_empty
    end
  end
end