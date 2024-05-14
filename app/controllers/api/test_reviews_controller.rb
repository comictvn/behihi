class Api::TestReviewsController < Api::BaseController
  include OauthTokensConcern
  before_action :doorkeeper_authorize!

  def show
    begin
      user_id = Integer(params[:userId])
    rescue ArgumentError
      render json: { message: "Invalid user ID format." }, status: :bad_request and return
    end

    user = User.find_by(id: user_id)
    unless user
      render json: { message: "User not found." }, status: :not_found and return
    end

    unless user == current_resource_owner
      render json: { message: "Unauthorized" }, status: :unauthorized and return
    end

    authorize user, policy_class: Api::TestReviewsPolicy

    test_review_service = TestReviewService.new
    test_review_data = test_review_service.compile_test_review(user_id)

    render json: { status: 200, answers: test_review_data }, status: :ok
  rescue StandardError => e
    render json: { message: e.message }, status: :internal_server_error
  end
end