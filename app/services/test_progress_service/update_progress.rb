
class TestProgressService
  include BaseService

  attr_reader :user_id, :question_id

  def initialize(user_id, question_id)
    @user_id = user_id
    @question_id = question_id
  end

  def update_progress
    validate_parameters

    TestProgress.transaction do
      test_progress = TestProgress.find_by!(user_id: @user_id)
      next_question_number = Question.where('id < ?', @question_id).count + 1

      if test_progress.current_question_number + 1 == next_question_number
        test_progress.increment!(:current_question_number)
        { status: 200, message: "Test progress updated successfully.", current_question_number: test_progress.current_question_number }
      else
        raise StandardError.new("Question sequence mismatch.")
      end
    end
  rescue ActiveRecord::RecordNotFound => e
    logger.error "TestProgressService#update_progress: #{e.message}"
    raise
  rescue StandardError => e
    logger.error "TestProgressService#update_progress: #{e.message}"
    raise
  end

  private

  def validate_parameters
    raise StandardError.new("Invalid input format.") unless integer_string?(@user_id) && integer_string?(@question_id)

    User.find(@user_id) # Validate user existence
    Question.find(@question_id) # Validate question existence
  end

  def integer_string?(str)
    Integer(str)
  rescue ArgumentError
    false
  end
end
