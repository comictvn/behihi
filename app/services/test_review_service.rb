
class TestReviewService
  def initialize(user_service: UserService.new, answer_service: AnswerService.new)
    @user_service = user_service
    @answer_service = answer_service
  end

  def compile_test_review(user_id)
    # Validate if the user exists
    user = @user_service.validate_user_exists(user_id)
    raise StandardError.new("User not found.") unless user

    # Retrieve user answers and format them
    answers = @answer_service.retrieve_user_answers(user_id: user_id)
    raise StandardError.new("User's test progress or answers do not exist.") if answers.empty?

    # Map answers to the required format
    answers.map do |answer|
      {
        question_id: answer.question_id,
        content: answer.question.content,
        selected_option: answer.option.content,
        is_correct: answer.is_correct?,
        submitted_at: answer.submitted_at.iso8601
      }
    end
  rescue ActiveRecord::RecordNotFound
    raise StandardError.new("Invalid user ID format.")
  end
end
