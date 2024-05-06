
class Api::AchievementsController < Api::BaseController
  before_action :doorkeeper_authorize!

  # POST /api/achievements/share
  def share
    user_id = params.require(:user_id)
    test_result_id = params.require(:test_result_id)

    begin
      shareable_content = AchievementService.generate_shareable_content(user_id, test_result_id)

      render json: {
        status: 200,
        shareable_link: shareable_content,
        message: "Share your achievement with your friends!"
      }, status: :ok
    rescue AchievementService::ShareAchievementError => e
      render json: { message: e.message }, status: :not_found
    rescue ActionController::ParameterMissing => e
      render json: { message: e.message }, status: :bad_request
    end
  end
end
