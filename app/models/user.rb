class User < ActiveRecord::Base

  include RedisTags

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable
  has_many :wikis, through: :collaborations, dependent: :destroy
  has_many :collaborations, dependent: :destroy
  
  uses_redis_tags :engine => $redis

  after_save :save_tags

  def save_tags
    self.tags_collection = ["#{self.name}"]
  end

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

  def self.find_by_name(name)
    User.where("lower(name) =?", name.downcase).first
  end

end
