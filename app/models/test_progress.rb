class TestProgress < ApplicationRecord
  # validations

  # end for validations

  def update_current_question_number!(new_question_number)
    with_lock do
      update_columns(current_question_number: new_question_number)
    end
  end

  # Use this method to handle the update of the test progress after a user submits an answer
  # It ensures the update is atomic and prevents race conditions

  # Additional methods and logic can be added here as needed

  class << self
  end
end
class TestProgress < ApplicationRecord
  # validations

  # end for validations

  class << self
  end
end
