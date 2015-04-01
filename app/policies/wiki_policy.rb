class WikiPolicy < ApplicationPolicy
  def index?
    true
  end

  def update?
    user.present? && ( record.public? || record.users.include?(user) || user.admin?)
  end

end
