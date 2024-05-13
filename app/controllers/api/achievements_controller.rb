
class Api::AchievementsController < Api::BaseController
  before_action :doorkeeper_authorize!
  rescue_from AchievementService::ShareAchievementError, with: :achievement_not_found
  rescue_from ActionController::ParameterMissing, with: :base_render_unprocessable_entity
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  # POST /api/achievements/share
  # This method handles the sharing of achievements
  def share
    user_id = params.require(:user_id)
    test_result_id = params.require(:test_result_id)

    shareable_content = AchievementService.share_achievement(user_id, test_result_id, current_resource_owner)

    render json: { status: 200, shareable_link: shareable_content[:link], message: shareable_content[:message] }, status: :ok
  end

  private

  def achievement_not_found(exception)
    render json: { message: exception.message }, status: :not_found
  end

  def base_render_unprocessable_entity(exception)
    render json: { message: exception.message }, status: :bad_request
  end

  def record_not_found(exception)
    render json: { message: exception.message }, status: :not_found
  end
end