
class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user
  belongs_to :option

  # validations
  validates :user_id, presence: true
  validates :question_id, presence: true
  validates :selected_option, presence: true
  validates :submitted_at, presence: true
  # end for validations

  class << self
  end
end
