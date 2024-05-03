
module Api
  class FeedbackController < BaseController
    before_action :doorkeeper_authorize!

    def show
      question_id = params[:questionId]
      user_id = params[:userId]

      # Validate presence of questionId and userId
      question = Question.find_by(id: question_id)
      user = User.find_by(id: user_id)

      # Return 404 if question or user not found
      return base_render_record_not_found(nil) unless question && user

      # Find the answer record associated with the userId and questionId
      answer = Answer.find_by(user_id: user_id, question_id: question_id)

      # Return the feedback response
      if answer
        render json: {
          status: 200,
          is_correct: answer.is_correct,
          feedback: answer.is_correct ? "Your answer is correct." : "Your answer is incorrect."
        }, status: :ok
      else
        # If no answer is found, it means no answer was submitted for the question by the user
        render json: {
          status: 404,
          is_correct: false,
          feedback: "No answer submitted for this question."
        }, status: :not_found
      end
    end
  end
end
