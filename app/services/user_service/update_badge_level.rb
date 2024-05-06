
module UserService
  class UpdateBadgeLevel
    def initialize(user_id, badge_level)
      @user_id = user_id
      @badge_level = badge_level
    end

    def call
      User.transaction do
        user = User.find(@user_id)
        user.update!(badge_level: @badge_level)
      end
      { success: true, message: 'Badge level updated successfully' }
    rescue ActiveRecord::RecordNotFound => e
      { success: false, message: e.message }
    rescue ActiveRecord::RecordInvalid => e
      { success: false, message: e.record.errors.full_messages.join(', ') }
    end
  end
end
