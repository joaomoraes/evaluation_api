# frozen_string_literal: true
class Api::V1::EmployeesController < Api::V1::BaseController
  before_action :authenticate_user!
  before_action :get_employee, only: [:show, :update, :destroy]
  before_action :authorize_user!

  def index
    render json: User.employee
  end

  def create
    @employee = CrudEmployeeService.create(employee_params)
    display_saved_employee
  end

  def show
    render json: @employee
  end

  def update
    @employee.update employee_params
    display_saved_employee
  end

  def destroy
    @employee.destroy
    render json: @employee
  end

  private

  def display_saved_employee
    if @employee.valid?
      render json: @employee
    else
      error_message message: @employee.errors.messages, status: :unprocessable_entity
    end
  end

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
