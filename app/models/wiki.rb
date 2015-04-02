class Wiki < ActiveRecord::Base
  belongs_to :user
  has_many :users, through: :collaborations, dependent: :destroy
  has_many :collaborations, dependent: :destroy

  has_many :taggings
  has_many :tags, through: :taggings

  validates :title, length: {minimum: 5}, presence: true
  validates :body, length: {minimum: 20}, presence: true
  validates :user, presence: true

  extend FriendlyId
  friendly_id :title, use: [:slugged, :history]

  def should_generate_new_friendly_id?
    slug.blank? || title_changed?
  end

  # Scopes
  default_scope { order('created_at DESC') }
  scope :public_wikis, -> { where(private: false) }

  def public?
    private == false
  end

  after_create :update_collaboration

  def update_collaboration
     Collaboration.create(wiki_id: self.id, user_id: self.user_id)
  end

  def collaborators
    users - [user]
  end

  def all_tags=(names)
    self.tags = names.split(",").map do |name|
      Tag.where(name: name.strip).first_or_create!
    end
  end

  def all_tags
    self.tags.map(&:name).join(", ")
  end

end