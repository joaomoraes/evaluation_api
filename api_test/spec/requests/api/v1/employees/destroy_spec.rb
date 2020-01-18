# frozen_string_literal: true
require 'rails_helper'

RSpec.describe "Employees/Destroy", type: :request do
  before do
    create_list(:user, 3, :admin)
    create_list(:user, 5, :employee)
  end
  let(:employee_id) { User.employee.last.id }
  let(:response_to_json) { JSON.parse response.body }

  describe 'signed in' do
    describe 'as admin' do
      let(:admin_user) { create :user, :admin }
      sign_in(:admin_user)

      describe 'destroy valid employee id' do
        it 'should respond with success' do
          delete employee_path(id: employee_id)
          expect(response).to have_http_status(:success)
          expect(response_to_json).not_to be_empty
          expect{ User.find(employee_id) }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end

      describe 'destroy valid admin id' do
        it 'should respond with not_found' do
          delete employee_path(id: User.admin.maximum(:id))
          expect(response).to have_http_status(:not_found)
          expect(response_to_json).to include('errors')
        end
      end

      describe 'destroy invalid user id' do
        it 'should respond with not_found' do
          delete employee_path(id: User.maximum(:id) + 1)
          expect(response).to have_http_status(:not_found)
          expect(response_to_json).to include('errors')
        end
      end
    end

    describe 'as employee' do
      let(:employee_user) { create :user, :employee }
      sign_in(:employee_user)

      it 'should respond with unauthorized' do
        delete employee_path(id: employee_id)

        expect(response).to have_http_status(:unauthorized)
        expect(response_to_json).to include('errors')
        expect(response_to_json['errors']).to include(I18n.t('controllers.api.v1.base.user_not_authorized'))
        expect{ User.find(employee_id) }.not_to raise_error
      end
    end
  end

  describe 'signed out' do
    it 'should respond with unauthorized' do
      delete employee_path(id: employee_id)
      expect(response).to have_http_status(:unauthorized)
      expect(response_to_json).to include('errors')
      expect(response_to_json['errors']).not_to be_empty
      expect{ User.find(employee_id) }.not_to raise_error
    end
  end
end