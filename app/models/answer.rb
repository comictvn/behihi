
class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  # validations
  # Assuming there is a validation for selected_option presence and belonging to the question
  validates :selected_option, presence: true
  validate :option_belongs_to_question

  def option_belongs_to_question
    errors.add(:selected_option, 'is not a valid option for this question') unless Option.valid_for_question?(selected_option, question_id)
  end
  # end for validations

  class << self
    def record_answer(user_id, question_id, selected_option)
      # Assuming the existence of a method to check if the option is valid for the question
      raise 'Invalid option' unless Option.valid_for_question?(selected_option, question_id)

      answer = create(user_id: user_id, question_id: question_id, selected_option: selected_option)
      answer.mark_as_final
      answer
    end
  end

  def mark_as_final
    update(submitted_at: Time.current)
  end
end
