# frozen_string_literal: true
require 'rails_helper'

RSpec.describe "Auth/Sign In", type: :request do
  describe 'sign in ' do
    let(:password) { '123456' }
    let(:user) { create :user, password: password, password_confirmation: password }

    describe 'with valid user values' do
      let(:user_args) { { email: user.email, password: password } } 
      before { post user_session_path, params: user_args }

      it 'should sign in' do
        expect(response).to have_http_status(:success)
        expect(response.headers['uid']).to eq(user.email)
        expect(response.headers).to include(*['uid', 'access-token', 'client'])
      end
    end

    describe 'with invalid user values' do
      describe 'as invald password' do
        let(:user_args) { { email: user.email, password: password+'78' } } 
        before { post user_session_path, params: user_args }

        it 'should sign in' do
          expect(response).to have_http_status(:unauthorized)
          expect(response.headers['uid']).not_to eq(user.email)
          expect(response.headers).not_to include(*['uid', 'access-token', 'client'])
        end
      end

      describe 'as invald email' do
        let(:user_args) { { email: user.email+'.com', password: password } } 
        before { post user_session_path, params: user_args }

        it 'should sign in' do
          expect(response).to have_http_status(:unauthorized)
          expect(response.headers['uid']).not_to eq(user.email)
          expect(response.headers).not_to include(*['uid', 'access-token', 'client'])
        end
      end
    end
  end
end