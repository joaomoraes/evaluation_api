# frozen_string_literal: true
class Api::V1::EmployeesController < Api::V1::BaseController
  before_action :authenticate_user!
  before_action :get_employee, only: [:show, :update, :destroy]
  before_action :authorize_user!

  def index
    render json: User.employee
  end

  def create
    if ['password', 'password_confirmation'].none? { |key| employee_params.key? key }
      employee_params['password'] = Devise.friendly_token.first(8) 
    end
    @employee = User.employee.create(employee_params)
    if @employee.valid?
      render json: @employee
    else
      error_message message: @employee.errors.messages, status: :unprocessable_entity
    end
  end

  def show
    render json: @employee
  end

  private

  def get_employee
    begin
      @employee = User.employee.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      error_message message: i18n_scoped(key:'get_employee'), status: :not_found
    end
  end

  def authorize_user!
    @employee ||= User
    authorize @employee, policy_class: EmployeePolicy
  end

  def employee_params
    params.require(:employee).permit(:name, :email, :password, :password_confirmation)
  end
end
