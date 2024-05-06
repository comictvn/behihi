
class Api::UsersController < ApplicationController
  before_action :authenticate_user!

  # Other actions ...

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

  def exit_test_completion_params
    params.permit(:user_id)
  end

  # Other private methods ...
end
