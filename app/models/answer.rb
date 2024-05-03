
class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  # validations
  validates :user_id, presence: true
  validates :question_id, presence: true
  validate :selected_option_belongs_to_question

  def selected_option_belongs_to_question
    errors.add(:selected_option, 'is not valid for this question') unless question.options.exists?(content: selected_option)
  end
  # end for validations

  class << self
    def record_answer(user_id, question_id, selected_option_id)
      answer = find_or_initialize_by(user_id: user_id, question_id: question_id)
      answer.selected_option = Option.find(selected_option_id).content
      answer.submitted_at = Time.current
      answer.save!
      answer
    end
  end
end
