class Api::TestRetakePolicy < ApplicationPolicy
  def initialize(user, record)
    @user = user
    @record = record
  end

  def create?
    user.is_a?(User) && record.id == user.id
  end
end