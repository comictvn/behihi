
class QuizPolicy < ApplicationPolicy
  def submit?
    user.is_a?(User)
  end
end
