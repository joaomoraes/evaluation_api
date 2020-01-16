# frozen_string_literal: true
require 'rails_helper'

RSpec.describe "Employees/Index", type: :request do
  before do
    create_list(:user, 3, :admin)
    create_list(:user, 5, :employee)
  end
  let(:response_to_json) { JSON.parse response.body }

  describe 'signed in' do
    describe 'as admin' do
      let(:admin_user) { create :user, :admin }
      sign_in(:admin_user)

      it 'should respond with success' do
        get employees_path

        expect(response).to have_http_status(:success)
        expect(response_to_json.count).to eq(5)
      end
    end

    describe 'as employee' do
      let(:employee_user) { create :user, :employee }
      sign_in(:employee_user)

      it 'should respond with unauthorized' do
        get employees_path

        expect(response).to have_http_status(:unauthorized)
        expect(response_to_json).to include('errors')
        expect(response_to_json['errors']).to include(I18n.t('controllers.api.v1.base.user_not_authorized'))
      end
    end
  end

  describe 'signed out' do
    it 'should respond with unauthorized' do
      get employees_path
      expect(response).to have_http_status(:unauthorized)
      expect(response_to_json).to include('errors')
      expect(response_to_json['errors']).not_to be_empty
    end
  end
end