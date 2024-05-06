
class Api::AchievementsController < ApplicationController
  before_action :doorkeeper_authorize!

  # POST /api/achievements/share
  def share
    user_id = params[:user_id]
    test_result_id = params[:test_result_id]

    user = User.find_by(id: user_id)
    test_result = TestResult.find_by(id: test_result_id, user_id: user_id)

    if user.nil? || test_result.nil?
      render json: { error: 'Invalid parameters' }, status: :unprocessable_entity
      return
    end

    shareable_content = AchievementService::ShareAchievement.new.generate_shareable_content(user_id, test_result_id)

    if shareable_content.present?
      render json: { shareable_link: shareable_content }, status: :ok
    else
      render json: { error: 'Unable to generate shareable content' }, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotFound => e
    render json: { error: e.message }, status: :not_found
  end
end
