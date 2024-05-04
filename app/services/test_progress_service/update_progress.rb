
class TestProgressService
  def self.update_custom_question_progress(user_id:, question_id:)
    ActiveRecord::Base.transaction do
      raise ActiveRecord::RecordNotFound unless User.exists?(user_id)
      raise ActiveRecord::RecordNotFound unless Question.exists?(question_id)

      test_progress = TestProgress.find_by!(user_id: user_id)
      test_progress.current_question_number = Question.where('id <= ?', question_id).count
      test_progress.total_questions += 1 if test_progress.current_question_number == test_progress.total_questions
      test_progress.save!
    end

    "Test progress updated successfully."
  rescue ActiveRecord::RecordNotFound
    "User or Question not found."
  rescue => e
    "Failed to update test progress: #{e.message}"
  end
end
