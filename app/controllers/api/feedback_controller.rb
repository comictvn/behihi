
module Api
  class FeedbackController < BaseController
    before_action :doorkeeper_authorize!
    before_action :load_question_and_user, only: [:show]

    # Load question and user from the database
    def load_question_and_user
      @question = Question.find_by(id: params[:questionId])
      @user = User.find_by(id: params[:userId])

      render json: { error: "Question not found." }, status: :not_found unless @question
      render json: { error: "User not found." }, status: :not_found unless @user
    end

    def show
      # Find the answer record associated with the userId and questionId
      answer = Answer.find_by(user_id: @user.id, question_id: @question.id)

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
