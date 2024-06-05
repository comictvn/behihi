
class Api::TestProgressController < Api::BaseController
  before_action :doorkeeper_authorize!

  def show
    user_id = params[:userId].to_i
    return render json: { error: "Invalid user ID format." }, status: :bad_request unless user_id.is_a?(Integer) && user_id > 0

    begin
      test_progress_data = TestProgressService.new.retrieve_test_progress(user_id)
      render json: test_progress_data, status: :ok
    rescue ActiveRecord::RecordNotFound
      render json: { error: "User not found." }, status: :not_found
    rescue StandardError => e
      render json: { error: e.message }, status: :internal_server_error
    end
  end
end
