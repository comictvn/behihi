
class TestResult < ApplicationRecord
  belongs_to :user
  validates :user_id, presence: true
  validates :score, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
  validates :badge_level, inclusion: { in: ['bronze', 'silver', 'gold'] }, allow_nil: true

  before_save :assign_badge_level, if: -> { badge_level.blank? }

  # Record the user's action of exiting the test completion screen
  def self.record_exit(user_id)
    user = User.find_by(id: user_id)
    raise ActiveRecord::RecordNotFound, "User not found" unless user

    # Placeholder for analytics or user behavior tracking
    # Analytics.record('test_completion_exit', user_id: user_id)

    # Placeholder for cleanup operations
    # Cleanup.perform(user_id: user_id)

    { message: 'User has exited the test completion screen and can be redirected.' }
  end

  private

  def assign_badge_level
    self.badge_level = case score
                       when 0..59 then 'bronze'
                       when 60..79 then 'silver'
                       when 80..100 then 'gold'
                       end
  end
end
