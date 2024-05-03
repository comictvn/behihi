
class TestProgressService::UpdateProgress
  include BaseService

  def initialize(user_id, current_question_number)
    @user_id = user_id
    @current_question_number = current_question_number
  end

  def call
    user = User.find(@user_id)
    test_progress = TestProgress.find_by!(user_id: user.id)

    TestProgress.transaction do
      test_progress.update!(current_question_number: @current_question_number + 1)
    end

    { current_question_number: test_progress.current_question_number, total_questions: test_progress.total_questions }
  rescue ActiveRecord::RecordNotFound => e
    logger.error "User or TestProgress not found: #{e.message}"
    raise
  rescue StandardError => e
    logger.error "An error occurred while updating test progress: #{e.message}"
    raise
  end

  private

  attr_reader :user_id, :current_question_number
end
