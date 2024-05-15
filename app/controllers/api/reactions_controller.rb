class Api::ReactionsController < Api::BaseController
  before_action :doorkeeper_authorize!

  def create
    user = User.find_by(id: reaction_params[:user_id])
    question = Question.find_by(id: reaction_params[:question_id])

    if user.nil?
      return base_render_record_not_found({ message: 'User not found.' })
    elsif question.nil?
      return base_render_record_not_found({ message: 'Question not found.' })
    elsif reaction_params[:reaction].blank?
      return base_render_unprocessable_entity({ message: 'Reaction is required.' })
    end

    faq_interaction = FaqInteraction.new(
      user: user,
      question: question,
      interaction_type: reaction_params[:reaction]
    )

    if faq_interaction.save
      render json: { message: 'The user\'s reaction has been captured successfully.' }, status: :ok
    else
      base_render_unprocessable_entity(faq_interaction)
    end
  end

  private

  def reaction_params
    params.permit(:user_id, :question_id, :reaction)
  end
end