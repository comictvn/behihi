class SocialShare < ApplicationRecord
  belongs_to :user
  belongs_to :achievement

  # validations

  # end for validations

  class << self
  end
end
