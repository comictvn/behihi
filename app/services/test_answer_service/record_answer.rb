
class TestAnswerService
  def self.record_answer(user_id:, question_id:, selected_option:)
    ActiveRecord::Base.transaction do
      raise ArgumentError, "Invalid input format." unless user_id.is_a?(Integer) && question_id.is_a?(Integer)
      raise ArgumentError, "Invalid input format." unless selected_option.is_a?(String)

      user = User.find_by(id: user_id)
      raise ActiveRecord::RecordNotFound, "User not found." unless user

      question = Question.find_by(id: question_id)
      raise ActiveRecord::RecordNotFound, "Question not found." unless question

      option = Option.find_by(question_id: question_id, content: selected_option)
      raise ActiveRecord::RecordNotFound, "Invalid option selected." unless option

      answer = Answer.find_or_initialize_by(user_id: user_id, question_id: question_id)
      answer.selected_option = selected_option
      answer.submitted_at = Time.current
      answer.option_id = option.id

      is_correct = option.is_correct
      answer.is_correct = is_correct

      answer.save!

      { success: true, answer_recorded: answer, is_correct: is_correct }
    end
  rescue ActiveRecord::RecordNotFound, ArgumentError => e
    { success: false, error: e.message }
  end
end
