
class AnswerService::RecordAnswer
  def initialize(user_id, question_id, selected_option_id)
    @user_id = user_id
    @question_id = question_id
    @selected_option_id = selected_option_id
  end

  def call
    ActiveRecord::Base.transaction do
      user = User.find_by(id: @user_id)
      raise 'User not found' unless user

      question = Question.find_by(id: @question_id)
      raise 'Question not found' unless question

      option = Option.find_by(id: @selected_option_id, question_id: @question_id)
      raise 'Option not found or does not belong to the question' unless option

      answer = Answer.find_or_initialize_by(user_id: @user_id, question_id: @question_id)
      answer.selected_option = option.content
      answer.submitted_at = Time.current

      if answer.save
        'Answer recorded or updated successfully'
      else
        raise 'Failed to record or update the answer'
      end
    end
  rescue => e
    e.message
  end
end
