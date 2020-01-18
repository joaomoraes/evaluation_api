# frozen_string_literal: true
require 'rails_helper'

RSpec.describe "Employees/Update", type: :request do
  before do
    create_list(:user, 3, :admin)
    create_list(:user, 5, :employee)
  end
  let(:employee_id) { User.employee.last.id }
  let(:response_to_json) { JSON.parse response.body }
  let(:update_employee_params) do
      { 
        employee: { 
          email: 'changedtestemail@testemail.com', 
          name: 'Changed Test Name', 
          password: 'changepass123', 
          password_confirmation: 'changepass123' 
        } 
      }
  end

  describe 'signed in' do
    describe 'as admin' do
      let(:admin_user) { create :user, :admin }
      sign_in(:admin_user)

      describe 'updating employee with valid params' do

        it 'should respond with success' do
          put employee_path(id: employee_id), params: update_employee_params
          employee = User.employee.find(employee_id)

          expect(response).to have_http_status(:success)
          expect(response_to_json).not_to be_empty
          [:email, :name].each { |attrib| expect(employee.send(attrib)).to eq(update_employee_params.dig(:employee, attrib)) }
          expect(employee.valid_password?(update_employee_params.dig(:employee, :password))).to be(true)
        end

        describe 'without password' do
          let(:employee_params_without_password) { update_employee_params.dup.tap{ |a| [:password, :password_confirmation].each{|key| a[:employee].delete(key)} } }
          it 'should respond with success' do
            put employee_path(id: employee_id), params: employee_params_without_password
            employee = User.employee.find(employee_id)

            expect(response).to have_http_status(:success)
            expect(response_to_json).not_to be_empty
            [:email, :name].each { |attrib| expect(employee.send(attrib)).to eq(update_employee_params.dig(:employee, attrib)) }
            expect(employee.valid_password?(update_employee_params.dig(:employee, :password))).to be(false)
          end
        end
      end

      describe 'updating employee with invalid params' do
        describe 'without password with password_confirmation' do
          let(:invalid_employee_params) { update_employee_params.dup.tap{ |a| a[:employee].delete(:password) } }
          it 'should respond with unprocessable_entity' do
            put employee_path(id: employee_id), params: invalid_employee_params
            employee = User.employee.find(employee_id)

            expect(response).to have_http_status(:unprocessable_entity)
            expect(response_to_json).to include('errors')
            [:email, :name].each { |attrib| expect(employee.send(attrib)).not_to eq(update_employee_params.dig(:employee, attrib)) }
            expect(employee.valid_password?(update_employee_params.dig(:employee, :password))).to be(false)
          end
        end
      end

      describe 'updating admin' do
        it 'should respond with not_found' do
          admin_id = User.admin.maximum(:id)
          put employee_path(id: admin_id), params: update_employee_params
          admin = User.admin.find(admin_id)

          expect(response).to have_http_status(:not_found)
          expect(response_to_json).to include('errors')
          [:email, :name].each { |attrib| expect(admin.send(attrib)).not_to eq(update_employee_params.dig(:employee, attrib)) }
          expect(admin.valid_password?(update_employee_params.dig(:employee, :password))).to be(false)
        end
      end
    end

    describe 'as employee' do
      let(:employee_user) { create :user, :employee }
      sign_in(:employee_user)

      it 'should respond with unauthorized' do
        put employee_path(id: employee_id), params: update_employee_params
        employee = User.employee.find(employee_id)

        expect(response).to have_http_status(:unauthorized)
        expect(response_to_json).to include('errors')
        expect(response_to_json['errors']).to include(I18n.t('controllers.api.v1.base.user_not_authorized'))
        [:email, :name].each { |attrib| expect(employee.send(attrib)).not_to eq(update_employee_params.dig(:employee, attrib)) }
        expect(employee.valid_password?(update_employee_params.dig(:employee, :password))).to be(false)
      end
    end
  end

  describe 'signed out' do
    it 'should respond with unauthorized' do
      put employee_path(id: employee_id), params: update_employee_params
      employee = User.employee.find(employee_id)

      expect(response).to have_http_status(:unauthorized)
      expect(response_to_json).to include('errors')
      expect(response_to_json['errors']).not_to be_empty
      [:email, :name].each { |attrib| expect(employee.send(attrib)).not_to eq(update_employee_params.dig(:employee, attrib)) }
      expect(employee.valid_password?(update_employee_params.dig(:employee, :password))).to be(false)
    end
  end
end