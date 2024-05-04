
class TestProgressService
  def self.update_progress(user_id, current_question_number)
    ActiveRecord::Base.transaction do
      user = User.find(user_id)
      test_progress = TestProgress.find_by!(user: user)

      # Update the current_question_number only if it has changed
      if test_progress.current_question_number != current_question_number
        test_progress.update!(current_question_number: current_question_number)
      end

      total_questions = test_progress.total_questions
      # Calculate the progress percentage and multiply by 100 to convert to percentage
      progress_percentage = ((current_question_number.to_f / total_questions) * 100).round(2)

      # Update the progress_percentage only if it has changed
      if test_progress.progress_percentage != progress_percentage
        test_progress.update!(progress_percentage: progress_percentage)
      end

      { current_question_number: test_progress.current_question_number, progress_percentage: progress_percentage }
    end
  rescue ActiveRecord::RecordNotFound => e
    raise e
  end
end
