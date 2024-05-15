class QuestionPolicy < ApplicationPolicy
  def tips?
    user.present?
  end
end