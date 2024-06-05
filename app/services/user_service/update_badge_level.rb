
module UserService
  class UpdateBadgeLevel
    BADGE_LEVELS = ['Bronze', 'Silver', 'Gold', 'Platinum'].freeze

    def initialize(user_id, score, badge_level = nil)
      @user_id = user_id
      @score = score
      @badge_level = badge_level || determine_badge_level(score)
    end

    def determine_badge_level(score)
      case score
      when 0..59 then 'Bronze'
      when 60..79 then 'Silver'
      when 80..89 then 'Gold'
      when 90..100 then 'Platinum'
      else
        raise ArgumentError, 'Invalid score'
      end
    end

    def create_test_result
      TestResult.create!(user_id: @user_id, score: @score, badge_level: @badge_level)
    rescue ActiveRecord::RecordInvalid => e
      raise ArgumentError, e.record.errors.full_messages.join(', ')
    end

    def call
      user = User.find_by(id: @user_id)
      raise ArgumentError, 'Invalid user_id' if user.nil?
      raise ArgumentError, 'Invalid score' unless @score.is_a?(Integer) && (0..100).include?(@score)
      raise ArgumentError, 'Invalid badge_level' unless BADGE_LEVELS.include?(@badge_level)

      User.transaction do
        user.update!(badge_level: @badge_level)
        create_test_result
      end
      { success: true, message: 'Test completed and score recorded', badge_level: @badge_level }
    rescue ActiveRecord::RecordNotFound => e
      { success: false, message: e.message }
    rescue ArgumentError => e
      { success: false, message: e.message }
    rescue ActiveRecord::RecordInvalid => e
      { success: false, message: e.record.errors.full_messages.join(', ') }
    end
  end
end
