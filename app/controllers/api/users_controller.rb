
class Api::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :doorkeeper_authorize!, only: [:record_test_completion]

  # Other actions ...

  # POST /api/users/test-completion
  def record_test_completion
    user_id = record_test_completion_params[:user_id]
    score = record_test_completion_params[:score]
    badge_level = record_test_completion_params[:badge_level]

    service_response = TestResultService::Create.new(
      user_id: user_id,
      score: score,
      badge_level: badge_level
    ).call

    if service_response[:message]
      render json: {
        status: 200,
        message: service_response[:message],
        badge_level: service_response[:badge_level]
      }, status: :ok
    else
      render json: { error: service_response[:error] }, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'User not found' }, status: :not_found
  end

  # POST /api/users/exit_test_completion
  def exit_test_completion
    user_id = exit_test_completion_params[:user_id]
    user = User.find(user_id)
    
    # Assuming ExitTestCompletion service exists and handles the logic
    # for a user exiting the test completion screen.
    service_response = UserService::ExitTestCompletion.new(user).execute
    
    if service_response[:success]
      render json: { message: service_response[:message] }, status: :ok
    else
      render json: { error: service_response[:error] }, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'User not found' }, status: :not_found
  end

  private

  def record_test_completion_params
    params.permit(:user_id, :score, :badge_level)
  end

  def exit_test_completion_params
    params.permit(:user_id)
  end

  # Other private methods ...
end
