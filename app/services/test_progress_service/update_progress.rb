
class TestProgressService
  def self.update_progress(user_id, current_question_number)
    ActiveRecord::Base.transaction do
      user = User.find(user_id)
      test_progress = TestProgress.find_by!(user: user)

      test_progress.update!(current_question_number: current_question_number)
      total_questions = test_progress.total_questions
      progress_percentage = (current_question_number.to_f / total_questions).round(2)

      test_progress.update!(progress_percentage: progress_percentage)

      { current_question_number: test_progress.current_question_number, progress_percentage: progress_percentage }
    end
  rescue ActiveRecord::RecordNotFound => e
    raise e
  end
end
