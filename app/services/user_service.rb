
class UserService
  def validate_user_exists(user_id)
    User.exists?(user_id)
  end

  def initiate_test_retake(user_id)
    unless validate_user_exists(user_id)
      return 'User does not exist'
    end

    begin
      ActiveRecord::Base.transaction do
        test_progress = TestProgress.find_or_initialize_by(user_id: user_id)
        test_progress.update!(
          current_question_number: 1,
          completed_at: nil,
          score: 0.0
        )
        Answer.where(user_id: user_id).delete_all
      end
    rescue ActiveRecord::RecordInvalid => e
      return "Failed to reset test: #{e.message}"
    end

    'Test has been reset and can be retaken'
  end

  def retrieve_test_review(user_id)
    return [] unless validate_user_exists(user_id)

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
  end
end
