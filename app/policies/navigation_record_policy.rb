class NavigationRecordPolicy < ApplicationPolicy
  def create?
    user.present?
  end
end