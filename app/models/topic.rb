class Topic < ApplicationRecord
  has_many :topic_details, dependent: :destroy

  belongs_to :user

  # validations

  # end for validations

  class << self
  end
end
