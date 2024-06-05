
module TestResultService
  class Create < ApplicationService
    attr_reader :user_id, :score, :badge_level

    def initialize(user_id:, score:, badge_level: nil)
      @user_id = user_id
      @score = score
      @badge_level = badge_level
    end

    def call
      ActiveRecord::Base.transaction do
        user = User.find(user_id)
        raise ActiveRecord::RecordNotFound, "User not found" unless user

        validate_score
        validate_badge_level! if badge_level

        @badge_level ||= DetermineBadgeLevel.new(score).call

        test_progress = TestProgress.create!(
          user_id: user_id,
          score: score,
          badge_level: @badge_level
        )

        update_user_profile(user, test_progress.badge_level)

        { status: 200, message: "Test completion and score recorded successfully.", badge_level: @badge_level }
      end
    rescue ActiveRecord::RecordInvalid => e
      { error: e.message }
    end

    private

    def validate_score
      raise ArgumentError, "Score must be an integer" unless score.is_a?(Integer)
      raise ArgumentError, "Score must be between 0 and 100" unless score.between?(0, 100)
    end

    def validate_badge_level!
      unless DetermineBadgeLevel::BADGE_LEVELS.keys.include?(badge_level.to_s.downcase)
        raise ArgumentError, "Invalid badge level"
      end
    end

    def update_user_profile(user, badge_level)
      # Assuming there is a method in the User model to update the badge level
      if badge_level
        user.update!(badge_level: badge_level)
      end
    end
  end
end
