
class User < ApplicationRecord
  has_many :answers, dependent: :destroy
  has_many :faq_searches, dependent: :destroy
  has_many :faq_interactions, dependent: :destroy
  has_many :topics, dependent: :destroy
  has_many :test_progresses, dependent: :destroy
  has_many :achievements, dependent: :destroy

  # validations

  # end for validations

  class << self
  end
end
