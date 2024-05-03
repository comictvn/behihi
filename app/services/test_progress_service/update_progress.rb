
class TestProgressService::UpdateProgress
  include BaseService

  def initialize(user_id, current_question_number)
    @user_id = user_id
    @current_question_number = current_question_number
  end

  def call
    user = User.find(@user_id)
    test_progress = TestProgress.find_by!(user_id: user.id)
    total_questions = Question.count

    validate_current_question_number!

    TestProgress.transaction do
      test_progress.update!(current_question_number: @current_question_number)
    end

    { status: 200, current_question_number: test_progress.current_question_number, total_questions: total_questions }
  rescue ActiveRecord::RecordNotFound => e
    logger.error "User or TestProgress not found: #{e.message}"
    raise
  rescue StandardError => e
    logger.error "An error occurred while updating test progress: #{e.message}"
    raise
  end

  private

  attr_reader :user_id, :current_question_number

  def validate_current_question_number!
    total_questions = Question.count
    unless @current_question_number.is_a?(Integer) && @current_question_number.between?(1, total_questions)
      raise StandardError.new("Invalid question number.")
    end
  end
end
