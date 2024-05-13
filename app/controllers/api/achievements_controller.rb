
class Api::AchievementsController < Api::BaseController
  before_action :doorkeeper_authorize!

  # POST /api/achievements/share
  # This method handles the sharing of achievements
  def share
    user_id = params.require(:user_id)
    test_result_id = params.require(:test_result_id)

    begin
      shareable_content = AchievementService.share_achievement(user_id, test_result_id)

      render json: {
        status: :ok,
        shareable_link: shareable_content[:link],
        message: shareable_content[:message]
      }, status: :ok
    rescue AchievementService::ShareAchievementError => e
      render json: { message: e.message }, status: :not_found
    rescue ActionController::ParameterMissing => e
      render json: { message: e.message }, status: :bad_request
    end
  end
end
