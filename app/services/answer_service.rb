
class AnswerService
  def retrieve_user_answers(user_id)
    answers = Answer.joins(:question, :option)
                    .where(user_id: user_id)
                    .where.not(submitted_at: nil)
                    .order('answers.created_at DESC')
                    .select('questions.content as question_content', 'options.content as selected_option_content', 'answers.is_correct')

    answers.map do |answer|
      {
        question_content: answer.question_content,
        selected_option_content: answer.selected_option_content,
        is_correct: answer.is_correct
      }
    end
  end
end
