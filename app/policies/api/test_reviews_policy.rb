
class Api::TestReviewsPolicy < ApplicationPolicy
  attr_reader :user, :userId

  def initialize(user, userId)
    @user = user
    @userId = userId
  end

  def retrieve?
    user.id == userId.to_i
  end
end
