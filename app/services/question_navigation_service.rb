
class QuestionNavigationService
  def navigate_next_question(user_id:, question_id:, selected_option:)
    ActiveRecord::Base.transaction do
      user = User.find(user_id)
      question = Question.find(question_id)
      
      if selected_option.present?
        option = question.options.find_by!(content: selected_option)
        Answer.create!(
          user: user,
          question: question,
          selected_option: option.content,
          is_correct: option.is_correct
        )
      end
      
      test_progress = TestProgress.find_by!(user_id: user_id)
      test_progress.increment!(:current_question_number)
      next_question = Question.find_by(id: test_progress.current_question_number)
      
      if next_question.nil?
        # Handle end of test logic here
      end
      
      { next_question_id: next_question&.id, current_question_number: test_progress.current_question_number, success: true }
    end
  rescue ActiveRecord::RecordNotFound => e
    { error: e.message, success: false }
  rescue ActiveRecord::RecordInvalid => e
    { error: e.message, success: false }
  end
end
