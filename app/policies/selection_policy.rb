
class SelectionPolicy < ApplicationPolicy
  def create?
    user.present? && user == current_user
  end

  private

  def current_user
    # Assuming OauthTokensConcern is included in ApplicationPolicy or elsewhere globally
    # and it provides a method to get the current authenticated user
    OauthTokensConcern.current_user
  end
end
