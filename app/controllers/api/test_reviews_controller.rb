
class Api::TestReviewsController < Api::BaseController
  include OauthTokensConcern
  before_action :doorkeeper_authorize!

  def show
    user_id = params[:userId]
    unless user_id =~ /\A\d+\z/
      return render json: { message: "Invalid user ID format." }, status: :bad_request
    end

    user_id = user_id.to_i
    user = User.find_by(id: user_id)
    unless user
      return render json: { message: "User not found." }, status: :not_found
    end

    # Ensure the authenticated user is the one requesting their test review
    unless user == current_resource_owner
      return render json: { message: "Unauthorized" }, status: :unauthorized
    end

    test_review_service = TestReviewService.new
    test_review_data = test_review_service.compile_test_review(user_id)

    render json: { status: 200, answers: test_review_data }, status: :ok
  rescue StandardError => e
    render json: { message: e.message }, status: :internal_server_error
  end
end
