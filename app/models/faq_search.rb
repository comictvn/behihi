
class FaqSearch < ApplicationRecord
  belongs_to :user

  # validations
  validates :search_query, presence: true
  validate :search_query_must_be_non_empty_string

  # end for validations

  class << self
    def log_search(search_query, user_id)
      create(search_query: search_query, user_id: user_id) if search_query.present? && search_query.is_a?(String) && !search_query.strip.empty?
    end
  end

  private

  def search_query_must_be_non_empty_string
    errors.add(:search_query, 'must be a non-empty string') unless search_query.is_a?(String) && !search_query.strip.empty?
  end
end
