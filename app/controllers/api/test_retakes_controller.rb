class Api::TestRetakesController < Api::BaseController
  before_action :doorkeeper_authorize!, only: [:create]
  before_action :validate_user_id_and_authorization, only: [:create]

  # POST /api/test_retakes
  def create
    user_id = params[:userId].to_i

    begin
      # Ensure the user_id is valid and the user is authorized to create a test retake
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
    user_id = params[:userId].to_i
    unless user_id.to_s.match?(/\A\d+\z/)
      render json: { message: "Invalid user ID format." }, status: :bad_request and return
    end

    unless User.exists?(user_id)
      render json: { message: "User not found." }, status: :not_found and return
    end
  end

  def validate_user_id_and_authorization
    validate_user_id
    unless Api::TestRetakePolicy.new(current_resource_owner, User.find(params[:userId])).create?
      render json: { message: "Unauthorized" }, status: :unauthorized and return
    end
  end

  # Other private methods (if any)

end