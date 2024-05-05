
module TestProgressService
  class ResetTest
    attr_reader :user_id

    def initialize(user_id)
      @user_id = user_id
    end

    def execute
      ActiveRecord::Base.transaction do
        user = User.find_by(id: user_id)
        raise 'User not found' unless user

        test_progress = user.test_progresses.last

        if test_progress
          test_progress.update!(
            current_question_number: 1,
            completed_at: nil,
            score: 0.0
          )
        else
          test_progress = user.test_progresses.create!(
            current_question_number: 1,
            total_questions: 0, # Assuming total_questions is required but not provided in the requirement
            score: 0.0
          )
        end

        user.answers.destroy_all
      end

      'Test has been reset and can be retaken'
    end
  end
end
