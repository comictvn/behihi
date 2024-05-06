
class Api::TestRetakesController < Api::BaseController
  before_action :doorkeeper_authorize!

  # POST /api/test_retakes
  def create
    user_id = params[:user_id].to_i

    begin
      message = TestProgressService::ResetTest.new(user_id).execute
      render json: { status: 200, message: message }, status: :ok
    rescue ActiveRecord::RecordNotFound => e
      render json: { message: e.message }, status: :not_found
    rescue StandardError => e
      render json: { message: e.message }, status: :internal_server_error
    end
  end

  def retake
    user_id = params[:userId].to_i

    begin
      # Use the ResetTest service to reset the test progress
      message = TestProgressService::ResetTest.new(user_id).execute
      render json: { status: 200, message: message }, status: :ok
    rescue ActiveRecord::RecordNotFound => e
      render json: { message: e.message }, status: :not_found
    rescue StandardError => e
      # Handle any exceptions and respond with appropriate error messages and status codes
      render json: { message: e.message }, status: :internal_server_error
    end
  end
end
