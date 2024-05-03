
module AnswerService
  class RecordUserAnswer
    attr_reader :user_id, :question_id, :selected_option

    def initialize(user_id, question_id, selected_option)
      raise StandardError, 'Invalid input format.' unless user_id.is_a?(Integer) && question_id.is_a?(Integer)
      raise StandardError, 'Invalid input format.' unless selected_option.is_a?(String)

      @user_id = user_id
      @question_id = question_id
      @selected_option = selected_option
    end

    def execute
      validate_user_and_question!
      validate_selected_option!
      answer = create_answer_record
      mark_answer_as_final(answer)
      { status: 200, message: 'Your answer has been recorded successfully.' }
    end

    private

    def validate_user_and_question!
      raise StandardError, 'User not found.' unless User.exists?(user_id)
      raise StandardError, 'Question not found.' unless Question.exists?(question_id)
    end

    def validate_selected_option!
      unless Option.exists?(content: selected_option, question_id: question_id)
        raise StandardError, 'Invalid selected option for the given question.'
      end
    end

    def create_answer_record
      Answer.create!(
        user_id: user_id,
        question_id: question_id,
        selected_option: selected_option
      )
    end

    def mark_answer_as_final(answer)
      answer.update!(submitted_at: Time.current)
    end
  end
end
