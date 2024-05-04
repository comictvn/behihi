
class TestAnswerService
  def self.record_answer(user_id:, question_id:, selected_option_id:)
    ActiveRecord::Base.transaction do
      user = User.find(user_id)
      question = Question.find(question_id)
      option_exists = Option.where(question_id: question_id, id: selected_option_id).exists?

      raise ActiveRecord::RecordNotFound unless option_exists

      answer = Answer.find_or_initialize_by(user_id: user_id, question_id: question_id)
      answer.selected_option_id = selected_option_id
      answer.submitted_at = Time.current

      is_correct = Option.find(selected_option_id).is_correct
      answer.is_correct = is_correct

      answer.save!

      { success: true, answer_recorded: answer, is_correct: is_correct }
    end
  rescue ActiveRecord::RecordNotFound => e
    { success: false, error: e.message }
  end
end
