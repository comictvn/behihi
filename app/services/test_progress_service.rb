
class TestProgressService < BaseService
  def retrieve_test_progress(user_id)
    raise ActiveRecord::RecordNotFound unless User.exists?(user_id)

    test_progress = TestProgress.find_or_initialize_by(user_id: user_id)
    if test_progress.new_record?
      test_progress.current_question_number = 1
      test_progress.total_questions = Question.count
      test_progress.save!
    end

    progress_percentage = (test_progress.current_question_number.to_f / test_progress.total_questions) * 100
    {
      current_question_number: test_progress.current_question_number,
      total_questions: test_progress.total_questions,
      progress_percentage: progress_percentage
    }
  rescue ActiveRecord::RecordNotFound => e
    logger.error "User not found: #{e.message}"
    raise
  rescue StandardError => e
    logger.error "Error retrieving test progress: #{e.message}"
    raise
  end
end
