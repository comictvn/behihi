
class UserService
  def validate_user_exists(user_id)
    User.exists?(user_id)
  end

  def retrieve_test_review(user_id)
    return [] unless validate_user_exists(user_id) # Ensure user exists

    answers = Answer.includes(:question, :option) # Preload associated records
                    .where(user_id: user_id).where.not(submitted_at: nil) # Check for non-null submitted_at
                    .order('questions.created_at ASC') # Order by question creation time

    answers.map do |answer|
      {
        question_content: answer.question.content,
        selected_option_content: answer.option.content,
        is_correct: answer.is_correct
      }
    end
  end
end
