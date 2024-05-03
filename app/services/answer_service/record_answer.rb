
module AnswerService
  class RecordAnswer
    def initialize(user_id:, question_id:, selected_option:)
      @user_id = user_id
      @question_id = question_id
      @selected_option = selected_option
    end

    def execute
      validate_selected_option!
      answer = create_answer_record
      mark_answer_as_final(answer)
      answer.id
    rescue StandardError => e
      raise e.message
    end

    private

    attr_reader :user_id, :question_id, :selected_option

    def validate_selected_option!
      options = Option.where(question_id: question_id).pluck(:content)
      raise 'Invalid selected option' unless options.include?(selected_option)
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
