
class TestProgressPolicy < ApplicationPolicy
  def update?
    user.id == record.user_id
  end
end
