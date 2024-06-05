class Option < ApplicationRecord
  has_many :answers, dependent: :destroy

  belongs_to :question

  # validations

  # end for validations

  class << self
  end
end
