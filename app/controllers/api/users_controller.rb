
class Api::UsersController < ApplicationController
  before_action :authenticate_user!, except: [:exit_test_completion, :record_test_completion]
  before_action :doorkeeper_authorize!, only: [:record_test_completion]
  before_action :set_user, only: [:show, :update, :destroy]
  before_action :validate_user, only: [:record_test_completion]

  # Other actions ...

  # POST /api/users/exit_test_completion
  def exit_test_completion
    user_id = params.require(:user_id)
    result = UserService::ExitTestCompletion.new(user_id).execute
    # Ensure the UserService::ExitTestCompletion service is implemented as per the requirement
    render json: { status: 200, message: result[:message] }, status: :ok
  rescue ActionController::ParameterMissing => e
    render json: { status: 400, message: e.message }, status: :bad_request
  rescue ActiveRecord::RecordNotFound
    render json: { status: 404, message: 'User not found.' }, status: :not_found
  rescue StandardError => e
    render json: { status: 500, message: e.message }, status: :internal_server_error
  end

  # POST /test-completion
  # Use "before_action" to call "doorkeeper_authorize!" to ensure the user is authenticated.
  def record_test_completion
    test_completion_params = params.require(:test_completion).permit(:user_id, :score, :badge_level)
    user_id = test_completion_params[:user_id]
    score = test_completion_params[:score]
    badge_level = test_completion_params[:badge_level]

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
    # Ensure that the "user_id" parameter corresponds to the current authenticated user or return an "Unauthorized" error if not.
  rescue ActiveRecord::RecordNotFound, ArgumentError => e
    render json: { status: 400, message: e.message }, status: :bad_request
  end

  private

  # Other private methods ...

  def test_completion_params
    params.require(:test_completion).permit(:user_id, :score, :badge_level)
  end

  def validate_user
    raise ActiveRecord::RecordNotFound unless User.exists?(params[:user_id])
    raise StandardError, 'Unauthorized' unless current_resource_owner.id == params[:user_id].to_i
  end

  # Assuming the existence of a method `current_resource_owner` that returns the current user based on the doorkeeper token
  def current_resource_owner
    User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
  end

  # Assuming the existence of a method `set_user` that sets the user based on the user_id parameter
  def set_user
    @user = User.find(params[:user_id])
  end
end
