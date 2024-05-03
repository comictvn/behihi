
class AnswerService::RecordAnswer < BaseService
  attr_reader :user_id, :question_id, :selected_option

  def initialize(user_id, question_id, selected_option)
    @user_id = user_id
    @question_id = question_id
    @selected_option = selected_option
  end

  def execute
    ActiveRecord::Base.transaction do
      user = User.find_by(id: user_id)
      raise StandardError, 'User not found' unless user

      question = Question.find_by(id: question_id)
      raise StandardError, 'Question not found' unless question

      option = Option.find_by(id: selected_option, question_id: question_id)
      raise StandardError, 'Option not found or does not belong to the question' unless option

      answer = Answer.find_or_initialize_by(user_id: user_id, question_id: question_id)
      answer.selected_option = selected_option
      answer.submitted_at = Time.current

      if answer.save
        { message: answer.persisted? ? 'Answer updated successfully' : 'Answer recorded successfully' }
      else
        raise StandardError, 'Failed to save answer'
      end
    end
  rescue StandardError => e
    { error: e.message }
  end
end
