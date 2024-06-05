
class TestProgress < ApplicationRecord
  # validations
  validates :current_question_number, numericality: { only_integer: true }
  validates :total_questions, numericality: { only_integer: true, greater_than: 0 }
  # end for validations

  class << self
  end
end
