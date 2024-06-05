
class Api::UsersController < ApplicationController
  before_action :doorkeeper_authorize!, only: [:exit_test_completion, :record_test_completion]

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

  rescue_from ActiveRecord::RecordNotFound do |e|
    render json: { status: 404, message: e.message }, status: :not_found
  end

  rescue_from ArgumentError do |e|
    render json: { status: 400, message: e.message }, status: :bad_request
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
    ).call

    if result[:message]
      render json: result, status: :ok
    else
      render json: { status: 422, message: result[:error] }, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotFound, ArgumentError => e
    render json: { status: 400, message: e.message }, status: :bad_request
  end
end
