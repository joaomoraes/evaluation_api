# frozen_string_literal: true
class Api::V1::BaseController < ApplicationController
  include Pundit
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def user_not_authorized
    error_message message: i18n_scoped(scope:'base'), status: :unauthorized
  end

  def error_message(message:, status: :bad_request)
    render json: { errors: [ message ] }, status: status
  end

  def i18n_scoped(key:caller_locations(1,1)[0].label, scope:controller_name)
    I18n.t("controllers.api.v1.#{scope}.#{key}")
  end

end