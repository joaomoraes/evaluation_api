class UserController < ApplicationController
  def index
    users = User.all
    render json: users
  end

  def reports
    reports = Report.all
    render json: reports
  end
end