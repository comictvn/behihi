
class User < ApplicationRecord
  has_many :answers, dependent: :destroy
  has_many :faq_searches, dependent: :destroy
  has_many :faq_interactions, dependent: :destroy

  # validations
  validates :id, presence: true
  # end for validations

  class << self
  end
end
