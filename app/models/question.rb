
class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  has_many :options, dependent: :destroy
  has_many :faq_interactions, dependent: :destroy

  has_many_attached :illustration, dependent: :destroy

  # validations

  # end for validations

  class << self
  end
end
