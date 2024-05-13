
module TestProgressService
  class ResetTest
    attr_reader :user_id

    def initialize(user_id)
      @user_id = user_id
    end

    def execute
      user_service = UserService.new

      ActiveRecord::Base.transaction do
        raise ActiveRecord::RecordNotFound, "User not found" unless user_service.validate_user_exists(user_id)

        user = User.find(user_id)
        total_questions = Question.count

        test_progress = user.test_progresses.last

        if test_progress
          test_progress.update!(
            current_question_number: 1,
            completed_at: nil,
            score: 0.0
          )
        else
          user.test_progresses.create!(
            total_questions: total_questions,
            current_question_number: 1,
            score: 0.0
          )
        end

        user.answers.destroy_all
      end

      'Test has been reset and can be retaken'
    end
  end
end

# Assuming UserService is defined elsewhere in the application and has the following method:
class UserService
  def validate_user_exists(user_id)
    User.exists?(user_id)
  end
end
