
module QuestionService
  class RetrieveQuestion
    def call(question_id:)
      # Ensure the question exists
      question = Question.find_by(id: question_id)
      raise ActiveRecord::RecordNotFound, "Question not found" unless question

      # Get the illustration reference if attached
      illustration_reference = question.illustration.attached? ? question.illustration.blob.signed_id : nil
      
      # Return the question details including the ID
      { status: 200, question: { id: question.id, content: question.content, illustration: illustration_reference } }
    end
  end
end
