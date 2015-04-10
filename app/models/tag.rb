class Tag < ActiveRecord::Base
  # has_many :taggings, dependent: :destroy
  # has_many :wikis, through: :taggings, dependent: :destroy
end