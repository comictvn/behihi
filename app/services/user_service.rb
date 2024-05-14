class UserService
  def validate_user_exists(user_id)
    User.exists?(user_id)
  end

  def retrieve_test_review(user_id)
    return 'User does not exist' unless validate_user_exists(user_id)

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

  def initiate_test_retake(user_id)
    unless validate_user_exists(user_id)
      return 'User does not exist'
    end

    begin
      test_progress = TestProgress.find_by(user_id: user_id)

      if test_progress
        test_progress.update(current_question_number: 1, completed_at: nil, score: 0.0)
        test_progress.answers.delete_all
      else
        TestProgress.create(user_id: user_id, current_question_number: 1, score: 0.0)
      end

      'Test has been reset and can be retaken'
    rescue => e
      "An error occurred while initiating test retake: #{e.message}"
    end
  end
end