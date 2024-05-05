
class RecordAnswer
  attr_reader :user_id, :question_id, :option_id, :is_correct

  def initialize(user_id, question_id, option_id)
    @user_id = user_id
    @question_id = question_id
    @option_id = option_id
  end

  def call
    user = User.find_by(id: user_id)
    return { status: 404, message: I18n.t('user.not_found'), is_correct: false } unless user

    question = Question.find_by(id: question_id)
    return { status: 404, message: I18n.t('question.not_found'), is_correct: false } unless question

    option = Option.find_by(id: option_id, question_id: question_id)
    return { status: 404, message: I18n.t('option.not_found_or_invalid'), is_correct: false } unless option

    is_correct = option.is_correct
    Answer.create!(user_id: user_id, question_id: question_id, option_id: option_id, is_correct: is_correct)

    test_progress = TestProgress.find_or_initialize_by(user_id: user_id)
    test_progress.current_question_number = (test_progress.current_question_number || 0) + 1
    test_progress.save!

    if test_progress.total_questions && test_progress.current_question_number == test_progress.total_questions
      # Calculate and record the user's test result
      correct_answers_count = Answer.where(user_id: user_id, is_correct: true).count
      # Record the result (implementation depends on the project's requirements)
    end

    { status: 200, message: I18n.t('answer.recorded_successfully'), is_correct: is_correct }
  rescue ActiveRecord::RecordInvalid => e
    { status: 422, message: e.record.errors.full_messages.to_sentence, is_correct: nil }
  rescue StandardError => e
    { status: 500, message: I18n.t('errors.internal_server_error'), is_correct: false }
  end
end
