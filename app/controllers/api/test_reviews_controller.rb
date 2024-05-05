
class Api::TestReviewsController < Api::BaseController
  before_action :doorkeeper_authorize!

  def show
    user_id = params[:userId].to_i
    return render json: { message: "Invalid user ID format." }, status: :bad_request unless user_id.is_a?(Integer) && user_id.to_s == params[:userId]

    begin
      @user_service.validate_user_exists(user_id)
    rescue ActiveRecord::RecordNotFound
      return render json: { message: "User not found." }, status: :not_found
    end

    test_review_service = TestReviewService.new
    test_review_data = test_review_service.compile_test_review(user_id)

    render json: { status: 200, answers: test_review_data }, status: :ok
  rescue StandardError => e
    render json: { message: e.message }, status: :internal_server_error
  end
end
