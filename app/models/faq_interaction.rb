class FaqInteraction < ApplicationRecord
  belongs_to :user
  belongs_to :question

  enum interaction_type: %w[viewed searched know_clicked view search answer click comment like dislike feedback WOW!! もしる skip],
       _suffix: true

  # validations

  # end for validations

  class << self
  end
end
