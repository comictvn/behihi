
module AnswerService
  class SubmitAnswerService
    class ValidationError < StandardError; end

    def initialize(user_id, question_id, selected_option)
      validate_parameters(user_id, question_id, selected_option)

      @user_id = user_id
      @question_id = question_id
      @selected_option = selected_option
    end

    def validate_parameters(user_id, question_id, selected_option)
      raise ValidationError, "User not found." unless User.exists?(user_id)
      raise ValidationError, "Question not found." unless Question.exists?(question_id)
      raise ValidationError, "Invalid input format." unless user_id.is_a?(Integer) && question_id.is_a?(Integer)
      raise ValidationError, "Invalid input format." unless selected_option.is_a?(String)

      options = Option.where(question_id: question_id).pluck(:content)
      unless options.include?(selected_option)
        raise ValidationError, "Invalid option selected."
      end
    end

    def execute
      # Step 1: Record the user's answer
      answer_id = record_user_answer

      # Step 2: Validate the selected option
      validate_selected_option

      # Step 3: Mark the answer as final
      mark_answer_as_final(answer_id)

      # Step 4: Prepare the response for redirection
      response = prepare_redirection_response(answer_id)

      response
    end

    private

    def record_user_answer
      # Assuming there is a method to create an answer record which returns the created answer's id
      answer = Answer.create(user_id: @user_id, question_id: @question_id, selected_option: @selected_option)
      answer.id
    end

    def validate_selected_option
      options = Option.where(question_id: @question_id).pluck(:id)
      raise ValidationError, 'Invalid selected option' unless options.include?(@selected_option.to_i)
      answer.option_id = @selected_option.to_i
      answer.save
    end

    def mark_answer_as_final(answer_id)
      Answer.find(answer_id).update(submitted_at: Time.current, final: true)
    end

    def prepare_redirection_response(answer_id)
      {
        answer_id: answer_id,
        question_id: @question_id,
        user_id: @user_id,
        redirect_to: 'feedback_page'
      }
    end

    def submit_answer(answer_id)
      Answer.find(answer_id).update(final: true)
    end
  end
end
