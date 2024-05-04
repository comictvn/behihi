
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

  def update_progress(user_id, question_id)
    raise ArgumentError, "Invalid input format." unless user_id.is_a?(Integer) && question_id.is_a?(Integer)
    raise ActiveRecord::RecordNotFound, "User not found." unless User.exists?(user_id)
    raise ActiveRecord::RecordNotFound, "Question not found." unless Question.exists?(question_id)

    test_progress = TestProgress.find_or_create_by(user_id: user_id)
    test_progress.update!(current_question_number: question_id)

    { status: 200, message: "Test progress updated successfully." }
  rescue ActiveRecord::RecordInvalid => e
    logger.error "Error updating test progress: #{e.message}"
    raise
  end
end
