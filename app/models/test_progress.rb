class TestProgress < ApplicationRecord
  has_many :answers, dependent: :destroy

  belongs_to :user

  # validations

  # end for validations

  class << self
  end
end
