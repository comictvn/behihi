
class NavigationService
  def check_unanswered_question(user_id, question_id)
    user = User.find_by(id: user_id)
    raise ActiveRecord::RecordNotFound, 'User not found.' if user.nil?

    question = Question.find_by(id: question_id)
    raise ActiveRecord::RecordNotFound, 'Question not found.' if question.nil?

    raise ActiveRecord::RecordNotFound, 'Please select an answer before proceeding.' unless Answer.exists?(user_id: user.id, question_id: question.id)

    { status: 200, message: 'Answer validated. You can proceed to the next question.' }
  end
end
