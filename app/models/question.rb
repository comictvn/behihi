class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  has_many :options, dependent: :destroy
  has_many :faq_interactions, dependent: :destroy

  has_many_attached :illustration, dependent: :destroy

  # validations

  # end for validations

  class << self
    def retrieve_question(question_id)
      raise ActiveRecord::RecordNotFound.new(I18n.t('activerecord.errors.messages.blank'), 'question_id') if question_id.blank?

      question = find_by(id: question_id)
      raise ActiveRecord::RecordNotFound.new(I18n.t('activerecord.errors.messages.invalid'), 'question_id') unless question

      illustration_reference = question.illustration.attached? ? question.illustration.blob.signed_id : nil
      { content: question.content, illustration: illustration_reference }
    end

  end
end
class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  has_many :options, dependent: :destroy
  has_many :faq_interactions, dependent: :destroy

  has_many_attached :illustration, dependent: :destroy

  # validations

  # end for validations

  class << self
  end
end
class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  has_many :options, dependent: :destroy
  has_many :faq_interactions, dependent: :destroy

  has_many_attached :illustration, dependent: :destroy

  # validations

  # end for validations

  class << self
  end
end
