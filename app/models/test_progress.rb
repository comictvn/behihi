class TestProgress < ApplicationRecord
  # validations

  # end for validations

  def update_progress_and_record_result(user_id, question_id, option_id, is_correct)
    self.current_question_number += 1
    self.save!

    if self.current_question_number >= self.total_questions
      correct_answers_count = Answer.where(user_id: user_id, is_correct: true).count
      # Assuming there is a method to calculate and record the test result
      # This method should be implemented according to the project's requirements
      calculate_and_record_test_result(user_id, correct_answers_count)
    end
  end

  private

  def calculate_and_record_test_result(user_id, correct_answers_count)
    # Placeholder for the actual implementation
    # This method should calculate the user's test result and record it accordingly
  end

  class << self
  end
end
class TestProgress < ApplicationRecord
  # validations

  # end for validations

  class << self
  end
end
