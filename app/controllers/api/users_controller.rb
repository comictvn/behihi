
class Api::UsersController < ApplicationController
  before_action :authenticate_user!, except: [:exit_test_completion]
  before_action :doorkeeper_authorize!, only: [:exit_test_completion]

  # Other actions ...

  # POST /api/users/exit_test_completion
  def exit_test_completion
    user_id = params.require(:user_id)
    result = UserService::ExitTestCompletion.new(user_id).call
    render json: { status: 200, message: result[:message] }, status: :ok
  rescue ActionController::ParameterMissing => e
    render json: { status: 400, message: e.message }, status: :bad_request
  rescue ActiveRecord::RecordNotFound
    render json: { status: 404, message: 'User not found.' }, status: :not_found
  rescue StandardError => e
    render json: { status: 500, message: e.message }, status: :internal_server_error
  end

  private

  # Other private methods ...
end
