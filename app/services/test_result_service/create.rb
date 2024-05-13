
module TestResultService
  class Create < ApplicationService
    attr_reader :user_id, :score, :badge_level

    def initialize(user_id:, score:, badge_level: nil)
      @user_id = user_id
      @score = score
      @badge_level = badge_level
    end

    def execute
      ActiveRecord::Base.transaction do
        user = User.find_by(id: user_id)
        validate_badge_level! if badge_level
        raise ActiveRecord::RecordNotFound, "User not found" unless user

        validate_score!
        determine_badge_level unless badge_level

        test_result = TestResult.create!(
          user_id: user_id,
          score: score,
          badge_level: badge_level
        )

        update_user_profile(user, badge_level)

        { message: "Test completion and score recorded successfully.", badge_level: badge_level }
      end
    rescue ActiveRecord::RecordInvalid => e
      { error: e.message }
    end

    private

    def validate_score!
      raise ArgumentError, "Score must be an integer" unless score.is_a?(Integer)
      raise ArgumentError, "Score must be between 0 and 100" unless score.between?(0, 100)
    end

    def validate_badge_level!
      valid_badge_levels = ['bronze', 'silver', 'gold']
      unless valid_badge_levels.include?(badge_level.to_s.downcase)
        raise ArgumentError, "Invalid badge level."
      end
    end

    def determine_badge_level
      # Assuming predefined criteria for badge levels
      case score
      when 80..100
        @badge_level = 'Gold'
      when 75..79
        @badge_level = 'Silver'
      when 60..74
        @badge_level = 'Bronze'
      else
        @badge_level = 'Participant'
      end unless badge_level.present?
    end

    def update_user_profile(user, badge_level)
      # Assuming there is a method in the User model to update the badge level
      user.update_badge_level(badge_level) if badge_level
    end
  end
end
