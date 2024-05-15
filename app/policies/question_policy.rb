class QuestionPolicy < ApplicationPolicy
  def additional_info?
    user.present?
  end
end