class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user
  belongs_to :option
  belongs_to :test_progress

  # validations

  # end for validations

  class << self
  end
end
