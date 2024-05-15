class TopicPolicy < ApplicationPolicy
  def access?
    record.user_id == user.id
  end
end