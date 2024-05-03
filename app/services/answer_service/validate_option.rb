
module AnswerService
  class ValidateOption
    def initialize(question_id, selected_option)
      @question_id = question_id
      @selected_option = selected_option
    end

    def execute
      Option.exists?(question_id: @question_id, content: @selected_option)
    end
  end
end
