class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  # validations

  # end for validations

  class << self
  end
end
