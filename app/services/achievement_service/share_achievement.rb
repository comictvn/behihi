
class AchievementService
  class ShareAchievementError < StandardError; end

  def self.share_achievement(user_id, test_result_id)
    user = User.find_by(id: user_id)
    raise ShareAchievementError, 'User not found' unless user

    test_result = TestProgress.find_by(id: test_result_id, user_id: user_id)
    raise ShareAchievementError, 'Test result not found' unless test_result

    message = "Share your achievement with your friends!"

    { status: 200, shareable_link: generate_link_for(test_result), message: message }
  end

  def self.generate_link_for(test_progress)
    "http://example.com/share?result=#{test_progress.id}"
  end
end
