
module FaqSearchService
  class ValidateUser
    def self.validate_user(user_id)
      User.exists?(user_id)
    end
  end
end
