
module UserService
  class ExitTestCompletion < BaseService
    def initialize(user_id)
      @user_id = user_id
    end

    def call
      return { error: 'User does not exist.' } unless User.exists?(@user_id)

      user = User.find(@user_id)
      record_exit_action(user)
      perform_cleanup_operations(user)
      { message: 'User has exited the test completion screen and can be redirected.' }
    rescue ActiveRecord::RecordNotFound => e
      Rails.logger.error "User not found: #{e.message}"
      { error: 'User not found.' }
    rescue StandardError => e
      Rails.logger.error "An error occurred: #{e.message}"
      { error: 'An unexpected error occurred.' }
    end

    private

    def record_exit_action(user)
      # Placeholder for analytics or user behavior tracking
      # Actual implementation would depend on the analytics tool being used
      # Example: AnalyticsService.record('exit_test_completion', user_id: user.id)
    end

    def perform_cleanup_operations(user)
      user.test_progresses.delete_all
      # Add any other cleanup logic needed
    end
  end
end
