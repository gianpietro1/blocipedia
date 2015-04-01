class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable
  has_many :wikis, through: :collaborations, dependent: :destroy
  has_many :collaborations, dependent: :destroy
  # has_many :wikis # can I remove this somehow? OK! got it by removing user association while creating.
  
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

  def refund_limit
    1 # days allowed for refund
  end

  def refundable?
    upgrade_since_days < refund_limit
  end

end
