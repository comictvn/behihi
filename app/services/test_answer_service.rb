
class TestAnswerService < BaseService
  def initialize(user_id, question_id, selected_option_id)
    @user = User.find_by(id: user_id)
    @question = Question.find_by(id: question_id)
    @selected_option = Option.find_by(id: selected_option_id, question_id: question_id)
  end

  def record_answer
    validate_inputs
    answer = Answer.find_or_initialize_by(user: @user, question: @question)
    answer.selected_option = @selected_option.content
    answer.submitted_at = Time.current
    answer.is_correct = @selected_option.is_correct
    answer.save!

    { message: 'Answer recorded successfully', is_correct: answer.is_correct }
  end

  private

  def validate_inputs
    raise 'Invalid user' unless @user
    raise 'Invalid question' unless @question
    raise 'Invalid option for the given question' unless @selected_option
  end
end
