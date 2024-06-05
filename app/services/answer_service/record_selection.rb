
class AnswerService::RecordSelection
  def execute(user_id, question_id, selected_option_content)
    ActiveRecord::Base.transaction do
      user = User.find_by(id: user_id)
      raise 'User not found.' unless user

      question = Question.find_by(id: question_id)
      raise 'Question not found.' unless question

      selected_option = question.options.find_by(content: selected_option_content)
      raise 'Invalid option selected.' unless selected_option

      answer = Answer.find_or_initialize_by(user_id: user_id, question_id: question_id)
      answer.selected_option = selected_option.content
      answer.submitted_at = Time.current
      answer.is_correct = selected_option.is_correct
      answer.save!

      { status: 200, message: 'Your answer has been recorded successfully.' }
    end
  rescue ActiveRecord::RecordInvalid => e
    { status: 422, message: e.record.errors.full_messages.join(', ') }
  rescue => e
    { status: 400, message: e.message }
  ensure
    ActiveRecord::Base.connection.close if ActiveRecord::Base.connection.open_transactions.zero?
  end
end
