class ErrorNotification < ApplicationRecord
  belongs_to :user

  enum status: %w[new viewed ignored resolved], _suffix: true
  enum priority: %w[low medium high], _suffix: true

  # validations

  # end for validations

  class << self
  end
end
