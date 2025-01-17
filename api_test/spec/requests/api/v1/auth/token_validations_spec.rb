# frozen_string_literal: true
require 'rails_helper'

RSpec.describe "Auth/Token Validations", type: :request do
  describe 'signed in' do
    let(:user) { create :user }
    sign_in(:user)

    it 'should respond with success' do
      get api_v1_auth_validate_token_path
      expect(response).to have_http_status(:success)
    end
  end

  describe 'signed out' do
    it 'should respond with unauthorized' do
      get api_v1_auth_validate_token_path
      expect(response).to have_http_status(:unauthorized)
    end
  end
end