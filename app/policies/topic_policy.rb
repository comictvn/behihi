class TopicPolicy < ApplicationPolicy
  def validate_access?
    record.user_id == user.id
  end
end