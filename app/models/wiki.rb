class Wiki < ActiveRecord::Base
  belongs_to :user
  has_many :users, through: :collaborations, dependent: :destroy
  has_many :collaborations, dependent: :destroy

  has_many :taggings, dependent: :destroy
  has_many :tags, through: :taggings, dependent: :destroy

  validates :title, length: {minimum: 5}, presence: true
  validates :body, length: {minimum: 20}, presence: true
  validates :user, presence: true

  after_create :update_collaboration

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

  def self.search(search)
    if search
      self.joins('LEFT OUTER JOIN "taggings" ON "taggings"."wiki_id" = "wikis"."id" LEFT OUTER JOIN "tags" ON "tags"."id" = "taggings"."tag_id"').uniq.where('tags.name LIKE ? OR wikis.title LIKE ?', "%#{search}%", "%#{search}%")
    else
      all
    end
  end

  private

  def update_collaboration
     Collaboration.create(wiki_id: self.id, user_id: self.user_id)
  end

end