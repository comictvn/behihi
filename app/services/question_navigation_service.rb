
class QuestionNavigationService
  def navigate_next_question(user_id:, question_id:)
    ActiveRecord::Base.transaction do
      user = User.find(user_id)
      question = Question.find_by(id: question_id)
      
      raise ActiveRecord::RecordNotFound, "Question not found." if question.nil?
      raise ArgumentError, "Invalid input format." unless question_id.is_a?(Integer)
      
      answer = Answer.find_by(user_id: user_id, question_id: question_id)
      raise StandardError, "Please select an answer before proceeding." if answer.nil? || answer.selected_option.blank?
      raise StandardError, "Failed to save the answer. Please try again." unless answer.persisted?
      
      test_progress = TestProgress.find_or_create_by!(user_id: user_id)
      next_question_number = test_progress.current_question_number + 1
      next_question = Question.find_by(id: next_question_number)
      
      raise ActiveRecord::RecordNotFound, "Next question not found." if next_question.nil?
      
      test_progress.update!(current_question_number: next_question_number)
      progress_percentage = (test_progress.current_question_number.to_f / test_progress.total_questions) * 100
      
      {
        status: 200,
        next_question_id: next_question.id,
        current_question_number: test_progress.current_question_number,
        total_questions: test_progress.total_questions,
        progress_percentage: progress_percentage.round,
        message: "You have successfully navigated to the next question."
      }
    end
  rescue ActiveRecord::RecordNotFound => e
    { status: 404, error: e.message, success: false }
  rescue ArgumentError => e
    { status: 422, error: e.message, success: false }
  rescue StandardError => e
    { status: 403, error: e.message, success: false }
  end
end
