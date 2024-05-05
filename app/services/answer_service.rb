
class AnswerService
  def retrieve_user_answers(user_id)
    answers = Answer.includes(:question, :option)
                    .where(user_id: user_id)
                    .where.not(submitted_at: nil)
                    .order('answers.created_at DESC')

    answers.map do |answer|
      {
        question_content: answer.question.content,
        selected_option_content: answer.option.content,
        is_correct: answer.is_correct
      }
    end
  end
end
