
class TestProgressService
  include BaseService

  def initialize(user_id, question_id)
    @user_id = user_id
    @question_id = question_id
  end

  def update_progress
    User.find(@user_id) # Validate user existence
    Question.find(@question_id) # Validate question existence

    TestProgress.transaction do
      test_progress = TestProgress.find_by!(user_id: @user_id)
      if test_progress.current_question_number == Question.where('id < ?', @question_id).count
        test_progress.increment!(:current_question_number)
      end
      test_progress
    end
  rescue ActiveRecord::RecordNotFound => e
    logger.error "TestProgressService#update_progress: #{e.message}"
    raise
  rescue StandardError => e
    logger.error "TestProgressService#update_progress: #{e.message}"
    raise
  end
end
