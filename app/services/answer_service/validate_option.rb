
module AnswerService
  class ValidateOption
    def initialize(question_id, selected_option)
      @question_id = question_id
      @selected_option = selected_option
    end

    def execute
      option = Option.find_by(question_id: @question_id, content: @selected_option)
      if option
        return option
      else
        return nil
      end
    end
  end
end
