class Api::NavigationRecordsController < Api::BaseController
  before_action :authenticate_user!

  def create
    user_id = params[:user_id]
    question_id = params[:question_id]
    navigation_choice = params[:navigation_choice]

    return render json: { error: "User not found." }, status: :not_found unless User.exists?(user_id)
    return render json: { error: "Question not found." }, status: :not_found unless Question.exists?(question_id)
    return render json: { error: "Navigation choice is required." }, status: :unprocessable_entity if navigation_choice.blank?

    # Assuming there is a model called NavigationRecord to save the navigation choice
    NavigationRecord.create!(user_id: user_id, question_id: question_id, navigation_choice: navigation_choice)

    render json: { message: "Navigation choice recorded successfully." }, status: :ok
  rescue ActiveRecord::RecordInvalid => e
    render json: { error: e.message }, status: :unprocessable_entity
  end
end