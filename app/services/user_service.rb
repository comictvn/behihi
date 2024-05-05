
class UserService
  def validate_user_exists(user_id)
    User.exists?(user_id)
  end

  def retrieve_test_review(user_id)
    if validate_user_exists(user_id)
      answers = Answer.includes(:question, :option)
                      .where(user_id: user_id, submitted_at: !nil)
                      .order('questions.created_at ASC')

      answers.map do |answer|
        {
          question_content: answer.question.content,
          selected_option_content: answer.option.content,
          is_correct: answer.is_correct
        }
      end
    else
      []
    end
  end
end
