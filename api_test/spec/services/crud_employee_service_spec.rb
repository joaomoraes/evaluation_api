# frozen_string_literal: true
require 'rails_helper'

RSpec.describe CrudEmployeeService do
  subject { described_class }
  let(:employee_attributes) {
    { 
      email: 'testemail@testemail.com', 
      name: 'Test Name', 
      password: 'pass123', 
      password_confirmation: 'pass123' 
    }.with_indifferent_access
  }

  describe "#create" do
    describe 'with valid employee params' do
      it 'should create an employee' do
        expect{ subject.create(employee_attributes) }.to change(User.employee, :count).by(1)
      end

      describe 'without password' do
        let(:employee_attributes_without_password) { employee_attributes.dup.tap{ |a| [:password, :password_confirmation].each{|key| a.delete(key)} } }
        it 'should create an employee' do
          expect{ subject.create(employee_attributes_without_password) }.to change(User.employee, :count).by(1)
        end
      end
    end

    describe 'creating an invalid employee' do
      describe 'without email' do
        let(:invalid_employee_attributes) { employee_attributes.dup.tap{ |a| a.delete(:email) } }
        it 'should respond with unprocessable_entity' do
          expect{ subject.create(invalid_employee_attributes) }.to change(User.employee, :count).by(0)
          expect(subject.create(invalid_employee_attributes)).to be_invalid
        end
      end

      describe 'without password with password_confirmation' do
        let(:invalid_employee_attributes) { employee_attributes.dup.tap{ |a| a.delete(:password) } }
        it 'should respond with unprocessable_entity' do
          expect{ subject.create(invalid_employee_attributes) }.to change(User.employee, :count).by(0)
          expect(subject.create(invalid_employee_attributes)).to be_invalid
        end
      end
    end
  end

end

