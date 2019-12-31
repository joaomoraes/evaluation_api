class Api::V1::EmployeesController < ApplicationController
  before_action :authenticate_user!
  before_action :get_employee, only: [:show, :update, :destroy]
  before_action :authorize_user!

  def index
    render User.employee
  end

  def create
    
  end

  def show
    
  end

  private

  def get_employee
    @employee = User.find(params[:id])
  end

  def authorize_user!
    @employee ||= User
    authorize @employee, policy_class: EmployeePolicy
  end

  def employee_params
    params.permits()
  end
end
