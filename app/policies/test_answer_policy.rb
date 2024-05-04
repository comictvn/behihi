
class TestAnswerPolicy < ApplicationPolicy
  def create?
    user.present?
  end
end
