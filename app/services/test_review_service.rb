
class TestReviewService
  def initialize(user_service: UserService.new, answer_service: AnswerService.new)
    @user_service = user_service
    @answer_service = answer_service
  end

  def compile_test_review(user_id)
    @user_service.validate_user_exists(user_id)
    answers = @answer_service.retrieve_user_answers(user_id: user_id)
    
    answers.map do |answer|
      {
        question_id: answer.question_id,
        content: answer.question.content,
        selected_option: answer.option.content,
        is_correct: answer.is_correct,
        submitted_at: answer.submitted_at.iso8601
      }
    end
  end
end
