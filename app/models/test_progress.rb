
class TestProgress < ApplicationRecord
  # validations
  validates :user_id, presence: true
  validates :current_question_number, presence: true

  # associations
  belongs_to :user
  belongs_to :question, optional: true
  # end for validations

  class << self
  end
end
