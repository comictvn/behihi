class TestProgress < ApplicationRecord
  # validations

  # end for validations

  belongs_to :user

  def self.retrieve_progress(user_id)
    user = User.find_by(id: user_id)
    raise ActiveRecord::RecordNotFound, 'User not found' unless user

    progress = find_or_initialize_by(user_id: user_id) do |new_progress|
      new_progress.current_question_number = 1
      new_progress.total_questions = Question.count
    end

    if progress.new_record?
      progress.save!
    else
      progress_percentage = (progress.current_question_number.to_f / progress.total_questions) * 100
    end

    { current_question_number: progress.current_question_number, total_questions: progress.total_questions, progress_percentage: progress_percentage }
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
