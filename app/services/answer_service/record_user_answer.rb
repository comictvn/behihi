
module AnswerService
  class RecordUserAnswer
    attr_reader :user_id, :question_id, :selected_option

    def initialize(user_id, question_id, selected_option)
      @user_id = user_id
      @question_id = question_id
      @selected_option = selected_option
    end

    def execute
      validate_selected_option!
      answer = create_answer_record
      mark_answer_as_final(answer)
      { answer_id: answer.id, message: 'Answer submitted successfully, redirecting to feedback page.' }
    end

    private

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
