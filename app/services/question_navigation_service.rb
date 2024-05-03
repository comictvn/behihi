
class QuestionNavigationService
  include BaseService

  def initialize(user_id, question_id)
    @user_id = user_id
    @question_id = question_id
  end

  def validate_navigation
    begin
      user_exists = User.exists?(@user_id)
      question_exists = Question.exists?(@question_id)

      unless user_exists && question_exists
        return { error: "User or question does not exist." }
      end

      answer_exists = Answer.exists?(user_id: @user_id, question_id: @question_id)

      if answer_exists
        { message: "User has answered the question. Proceed to the next question." }
      else
        { error: "User must select an answer before proceeding." }
      end
    rescue => e
      logger.error "QuestionNavigationService#validate_navigation: #{e.message}"
      { error: "An error occurred while validating navigation." }
    end
  end
end
