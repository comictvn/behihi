
class Api::UsersController < ApplicationController
  before_action :authenticate_user!, except: [:record_test_completion]
  before_action :doorkeeper_authorize!, only: [:exit_test_completion, :record_test_completion, :exit]

  # Other actions ...

  # POST /api/users/exit_test_completion
  def exit_test_completion
    doorkeeper_authorize!
    # Ensure that the user_id parameter is present and corresponds to an existing user
    user_id = params.require(:user_id)
    user = User.find(user_id)
    result = UserService::ExitTestCompletion.new(user_id).call
    render json: { status: 200, message: result[:message] }, status: :ok
  rescue ActionController::ParameterMissing => e
    render json: { status: 400, message: e.message }, status: :bad_request
  rescue ActiveRecord::RecordNotFound
    render json: { status: 404, message: 'User not found or invalid user_id.' }, status: :not_found
  rescue StandardError => e
    render json: { status: 500, message: e.message }, status: :internal_server_error
  end

  # POST /api/users/exit
  def exit
    result = UserService::ExitTestCompletion.new(params.require(:user_id)).call
    if result[:error].present?
      render json: { message: result[:error] }, status: :unprocessable_entity
    else
      render json: { message: result[:message] }, status: :ok
    end
  rescue ActionController::ParameterMissing => e
    render json: { message: e.message }, status: :bad_request
  end

  # POST /test-completion
  def record_test_completion
    user_id = params.require(:user_id)
    score = params.require(:score)
    badge_level = params[:badge_level]

    result = TestResultService::Create.new(
      user_id: user_id,
      score: score,
      badge_level: badge_level
    ).execute

    if result[:message]
      render json: result, status: :ok
    else
      render json: { status: 422, message: result[:error] }, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotFound, ArgumentError => e
    render json: { status: 400, message: e.message }, status: :bad_request
  end

  private

  # Other private methods ...
end
