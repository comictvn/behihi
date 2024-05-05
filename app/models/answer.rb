
class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user
  belongs_to :option

  # validations
  validates :user_id, presence: true
  validates :question_id, presence: true
  validates :option_id, presence: true

  validate :user_must_exist
  validate :question_must_exist
  validate :option_must_exist

  # end for validations

  class << self
  end

  private

  def user_must_exist
    errors.add(:user_id, "is invalid") unless User.exists?(self.user_id)
  end

  def question_must_exist
    errors.add(:question_id, "is invalid") unless Question.exists?(self.question_id)
  end

  def option_must_exist
    question = Question.find_by(id: self.question_id)
    errors.add(:option_id, "is invalid") unless question&.options&.exists?(self.option_id)
  end
end
