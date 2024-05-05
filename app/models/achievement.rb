class Achievement < ApplicationRecord
  belongs_to :user

  has_many_attached :badge, dependent: :destroy

  # validations

  # end for validations

  class << self
  end
end
