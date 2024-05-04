
class NavigationService
  def check_unanswered_question(user_id, question_id)
    user = User.find(user_id)
    question = Question.find(question_id)

    unless Answer.exists?(user_id: user.id, question_id: question.id)
      return { error: 'You must select an answer before proceeding.' }
    end

    { message: 'You can proceed to the next question.' }
  end
end
