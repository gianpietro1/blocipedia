class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable
  has_many :wikis

  def admin?
    role == 'admin'
  end

  def premium?
    role == 'premium'
  end

  def upgrade_since_days
    if upgrade_date
      ((Time.now - upgrade_date)/86400).round
    else
      nil
    end
  end

  def refundable?
    upgrade_since_days <=0
  end

end
