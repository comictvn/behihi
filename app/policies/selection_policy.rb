
class SelectionPolicy < ApplicationPolicy
  def create?
    user.present?
  end
end
