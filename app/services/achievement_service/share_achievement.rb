
class AchievementService
  class ShareAchievementError < StandardError; end

  def self.generate_shareable_content(user_id, test_result_id)
    user = User.find_by(id: user_id)
    raise ShareAchievementError, 'User not found' unless user

    test_progress = user.test_progresses.find_by(id: test_result_id)
    raise ShareAchievementError, 'Test result not found' unless test_progress

    shareable_link = generate_link_for(test_progress)

    {
      link: shareable_link,
      message: "Share your achievement with your friends!"
    }
  rescue ActiveRecord::RecordNotFound => e
    raise ShareAchievementError, e.message
  end

  def self.generate_link_for(test_progress)
    "http://example.com/share?result=#{test_progress.id}"
  end
end
