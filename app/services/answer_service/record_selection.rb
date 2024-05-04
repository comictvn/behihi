
class AnswerService::RecordSelection
  def execute(user_id, question_id, selected_option_id)
    ActiveRecord::Base.transaction do
      user = User.find_by(id: user_id)
      raise 'User does not exist' unless user

      question = Question.find_by(id: question_id)
      raise 'Question does not exist' unless question

      selected_option = question.options.find_by(id: selected_option_id)
      raise 'Selected option does not exist' unless selected_option

      answer = Answer.find_by(user_id: user_id, question_id: question_id)

      if answer
        answer.update!(selected_option_id: selected_option_id, submitted_at: Time.current, is_correct: selected_option.is_correct)
      else
        answer = Answer.create!(user_id: user_id, question_id: question_id, selected_option_id: selected_option_id, submitted_at: Time.current, is_correct: selected_option.is_correct)
      end
    end

    { message: 'Answer recorded or updated successfully', is_correct: selected_option.is_correct }
  rescue => e
    { message: e.message, is_correct: false }
  ensure
    ActiveRecord::Base.connection.close if ActiveRecord::Base.connection.open_transactions.zero?
  end
end
