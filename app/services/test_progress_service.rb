
class TestProgressService < BaseService
  def initialize(user_id, question_id)
    @user_id = user_id
    @question_id = question_id
  end

  def update_custom_question_progress
    ActiveRecord::Base.transaction do
      user = User.find(@user_id)
      question = Question.find_by_id(@question_id) || Question.create!(custom_question_params)
      test_progress = TestProgress.find_or_create_by!(user: user)

      test_progress.current_question_number = question.id # Assuming question.id reflects the position
      test_progress.total_questions += 1 if question_is_last?(question)
      test_progress.save!
    end
  rescue ActiveRecord::RecordNotFound => e
    logger.error "Record not found: #{e.message}"
    raise
  rescue ActiveRecord::RecordInvalid => e
    logger.error "Record invalid: #{e.message}"
    raise
  end

  private

  def question_is_last?(question)
    # Logic to determine if the question is the last one
    # Placeholder for actual implementation
  end

  def custom_question_params
    # Params for creating a custom question
    # Placeholder for actual implementation
  end
end
