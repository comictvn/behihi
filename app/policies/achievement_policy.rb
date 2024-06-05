
class AchievementPolicy < ApplicationPolicy
  def share?
    user.present? && record.user_id == user.id
  end
end
