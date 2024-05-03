
class AnswerService::RecordSelection
  def execute(user_id, question_id, selected_option_id)
    ActiveRecord::Base.transaction do
      raise 'User does not exist' unless User.exists?(user_id)
      raise 'Question does not exist' unless Question.exists?(question_id)
      raise 'Selected option does not exist' unless Option.exists?(question_id: question_id, id: selected_option_id)

      answer = Answer.find_by(user_id: user_id, question_id: question_id)
      selected_option = Option.find(selected_option_id)

      if answer
        answer.update(selected_option_id: selected_option_id, submitted_at: Time.current, is_correct: selected_option.is_correct)
      else
        answer = Answer.create(user_id: user_id, question_id: question_id, selected_option_id: selected_option_id, submitted_at: Time.current, is_correct: selected_option.is_correct)
      end
    end

    { message: 'Answer recorded or updated successfully', is_correct: selected_option.is_correct }
  rescue => e
    { message: e.message, is_correct: false }
  end
end
