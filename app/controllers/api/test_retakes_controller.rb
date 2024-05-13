
class Api::TestRetakesController < Api::BaseController
  before_action :doorkeeper_authorize!, only: [:create]
  before_action :validate_user_id, only: [:create]

  # POST /api/test_retakes
  def create
    user_id = params[:userId].to_i

    begin
      message = TestProgressService::ResetTest.new(user_id).execute
      render json: { status: 200, message: message }, status: :ok
    rescue ActiveRecord::RecordNotFound => e
      render json: { message: e.message }, status: :not_found
    rescue StandardError => e
      render json: { message: e.message }, status: :internal_server_error
    end
  end

  private

  def validate_user_id
    unless params[:userId].to_s.match?(/\A\d+\z/)
      render json: { message: "Invalid user ID format." }, status: :bad_request and return
    end

    unless User.exists?(params[:userId].to_i)
      render json: { message: "User not found." }, status: :not_found and return
    end
  end

  # Other private methods (if any)

end
