
class Api::TestRetakesController < Api::BaseController
  before_action :doorkeeper_authorize!

  def retake
    user_id = params[:userId]

    # Validate the "userId" parameter to ensure it is an integer
    unless user_id.is_a?(Integer)
      return render json: { message: "Invalid user ID format." }, status: :bad_request
    end

    # Validate the "userId" parameter to ensure it corresponds to an existing user
    user = User.find_by(id: user_id)
    unless user
      return render json: { message: "User not found." }, status: :not_found
    end

    begin
      # Use the ResetTest service to reset the test progress
      message = TestProgressService::ResetTest.new(user_id).execute
      render json: { status: 200, message: message }, status: :ok
    rescue StandardError => e
      # Handle any exceptions and respond with appropriate error messages and status codes
      render json: { message: e.message }, status: :internal_server_error
    end
  end
end
