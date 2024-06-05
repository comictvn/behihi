class User < ApplicationRecord
  has_many :answers, dependent: :destroy
  has_many :faq_searches, dependent: :destroy
  has_many :faq_interactions, dependent: :destroy
  has_one :test_progress, dependent: :destroy

  # validations

  # end for validations

  class << self
  end
end
class User < ApplicationRecord
  has_many :answers, dependent: :destroy
  has_many :faq_searches, dependent: :destroy
  has_many :faq_interactions, dependent: :destroy

  # validations

  # end for validations

  class << self
  end
end
class User < ApplicationRecord
  has_many :answers, dependent: :destroy
  has_many :faq_searches, dependent: :destroy
  has_many :faq_interactions, dependent: :destroy

  # validations

  # end for validations

  class << self
  end
end
