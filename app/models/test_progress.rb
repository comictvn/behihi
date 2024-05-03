
class TestProgress < ApplicationRecord
  # validations
  validates :current_question_number, presence: true, numericality: { only_integer: true }
  validates :total_questions, presence: true, numericality: { only_integer: true }
  # end for validations

  class << self
  end
end
