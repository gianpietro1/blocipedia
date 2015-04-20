class Wiki < ActiveRecord::Base

  attr_writer :all_tags

  belongs_to :user
  has_many :users, through: :collaborations, dependent: :destroy
  has_many :collaborations, dependent: :destroy

  # has_many :taggings, dependent: :destroy
  # has_many :tags, through: :taggings, dependent: :destroy

  validates :title, length: {minimum: 5}, presence: true
  validates :body, length: {minimum: 20}, presence: true
  validates :user, presence: true

  after_save :set_tags
  after_create :update_collaboration

  extend FriendlyId
  friendly_id :title, use: [:slugged, :history]

  def should_generate_new_friendly_id?
    slug.blank? || title_changed?
  end

  # Scopes
  default_scope { order('created_at DESC') }
  scope :public_wikis, -> { where(private: false) }

  # Simple methods
  def public?
    private == false
  end

  def collaborators
    users - [user]
  end

  # Tags
  def set_tags
    
    current_tags = self.all_tags.split(",")
    new_tags = @all_tags.split(",")
    
    new_tags.each do |tagg|
      $redis.pipelined do
        $redis.sadd("wiki-#{self.id}",tagg)
        $redis.sadd("tag-#{tagg}",self.id)
      end
    end

    @diff_tags = current_tags - new_tags

    unless @diff_tags.empty?
      @diff_tags.each do |diff|
        $redis.pipelined do
          $redis.srem("tag-#{diff}",self.id)
          $redis.srem("wiki-#{self.id}",diff)
        end
      end
    end


 
  end

  def all_tags
     $redis.smembers("wiki-#{self.id}").join(",")
  end

  def self.search(search)
    if search == ""
      all
    elsif search
        Wiki.where(id: $redis.smembers("tag-#{search}"))
    else
      all
    end
  end

  # Private methods
  private

  def update_collaboration
     Collaboration.create(wiki_id: self.id, user_id: self.user_id)
  end

end