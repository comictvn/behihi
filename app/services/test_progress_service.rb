
# typed: true
module App
  module Services
    class TestProgressService < BaseService
      def update_progress(user_id, question_id) # method implementation
        ActiveRecord::Base.transaction do
          user = User.find(user_id)
          question = Question.find(question_id)
          test_progress = TestProgress.find_by(user_id: user.id)

          if test_progress && question.id == test_progress.current_question_number + 1
            test_progress.increment!(:current_question_number)
          end

          { success: true, current_question_number: test_progress.current_question_number }
        rescue ActiveRecord::RecordNotFound => e
          logger.error "Record not found: #{e.message}"
          { success: false, error: "Record not found: #{e.message}" }
        rescue StandardError => e
          logger.error "Standard error: #{e.message}"
          { success: false, error: "Standard error: #{e.message}" }
        end
      end
    end
  end
end
