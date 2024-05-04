
module QuestionService
  class RetrieveQuestion
    def call(question_id:)
      question = Question.find_by(id: question_id)
      raise ActiveRecord::RecordNotFound, "Question not found" unless question

      illustration_reference = question.illustration.attached? ? question.illustration.blob.signed_id : nil
      { content: question.content, illustration: illustration_reference }
    end
  end
end
