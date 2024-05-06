
class AchievementService
  class ShareAchievementError < StandardError; end

  def self.generate_shareable_content(user_id, test_result_id)
    user = User.find_by(id: user_id)
    raise ShareAchievementError, 'User not found' unless user

    achievement = user.achievements.find_by(id: test_result_id)
    raise ShareAchievementError, 'Test result not found' unless achievement

    # Assuming the application has a method to generate a shareable link
    shareable_link = generate_link_for(achievement)

    shareable_link
  rescue ActiveRecord::RecordNotFound => e
    raise ShareAchievementError, e.message
  end

  def self.generate_link_for(achievement)
    # Placeholder for link generation logic
    # This should include the user's score and badge or level achieved
    # For example: "https://example.com/share?score=#{achievement.score}&badge=#{achievement.badge}"
    "https://example.com/share?score=#{achievement.score}&badge=#{achievement.badge}"
  end
end
